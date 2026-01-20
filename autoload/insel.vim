" © 2026 Max Karou. All Rights Reserved.
" Licensed under Apache Version 2.0, or MIT License, at your discretion.
"
" Author: Max Karou <maxkarou@protonmail.com>
" Source: https://github.com/52/vim
"
" Apache License: http://www.apache.org/licenses/LICENSE-2.0
" MIT License: http://opensource.org/licenses/MIT
"
" Usage of this file is permitted solely under a sanctioned license.

if !has('vim9script')
  finish
endif

vim9script

# Interactive selection interface (INSEL).
# Provides a way to select and filter items from a list.
#
# Filters:
#
# Filters control how the query narrows down the list.
# Two are provided by default in DEFAULT_FILTERS:
#
# fuzzy -> Matches characters in order, ranked by score.
# regex -> Matches the query as case-insensitive pattern.
#
# Custom filters can be added by passing a dictionary mapping names to
# functions with the signature FilterFn.
#
# Actions:
#
# Actions define what happens when a key(-combination) is pressed.
# They are passed as a dictionary mapping keys to callbacks.
#
# Each receives the class instance which can access the selected item with the
# Item() method and the current query with the Query() method, as well as
# other functions exposed through the interface definition.
#
# {
#   "\<CR>": (i) => {
#     const item = i.Item()
#     i.Close()
#     execute 'edit ' .. fnameescape(item)
#   },
# }
#
# Default actions are defined in DEFAULT_ACTIONS:
#
# Ctrl-n    -> Move to next candidate.
# Ctrl-p    -> Move to previous candidate.
# Ctrl-f    -> Cycle through available filters.
# Ctrl-c    -> Close the INSEL window.
# Backspace -> Remove a character from the query.
#
# Usage:
#
# var i = insel.Insel.new(items, filters, actions)
# i.Open()

# Defines the public interface for INSEL.
# Methods added here are exposed to actions.
export interface IInsel
  # Opens a new interactive session.
  def Open(): void
  # Closes the interactive session.
  def Close(): void
  # Move the cursor to the next candidate.
  def Next(): void
  # Move the cursor to the previous candidate.
  def Prev(): void
  # Rotate through the registered filter functions.
  def Cycle(): void
  # Remove the last character from the query.
  def Pop(): void
  # Returns the currently selected candidate.
  def Item(): string
  # Returns the current query.
  def Query(): string
endinterface

# Function signature for filters.
type FilterFn = func(list<string>, string): list<string>

# Function signature for actions.
type ActionFn = func(IInsel): void

# Filters the provided list using Vim's built-in fuzzy matching.
# Matches characters from the query string in the given order.
# If the query is empty, the unfiltered list is returned.
def FuzzyFilter(list: list<string>, query: string): list<string>
  return empty(query) ? list : matchfuzzy(list, query)
enddef

# Filters the provided list using case-insensitive regular expression.
# The query string is treated as a regex pattern to narrow down candidates.
# If the query is empty, the unfiltered list is returned.
def RegexFilter(list: list<string>, query: string): list<string>
  return empty(query) ? list : copy(list)->filter((_, v) => v =~? query)
enddef

# Dictionary mapping identifiers to their filter function.
# These filters act as default unless explicitly overridden.
const DEFAULT_FILTERS: dict<FilterFn> = {
  'fuzzy': FuzzyFilter,
  'regex': RegexFilter,
}

# Dictionary mapping keys to their action function.
# These mappings act as default unless explicitly overridden.
const DEFAULT_ACTIONS: dict<ActionFn> = {
  "\<C-n>": (i: IInsel) => i.Next(),
  "\<C-p>": (i: IInsel) => i.Prev(),
  "\<C-f>": (i: IInsel) => i.Cycle(),
  "\<BS>":  (i: IInsel) => i.Pop(),
}

# Implementation of the INSEL interface.
export class Insel implements IInsel
  const HEIGHT = 12

  var __items: list<string>
  var __filters: dict<FilterFn>
  var __actions: dict<ActionFn>

  var __query: string
  var __matches: list<string>

  var __offset: number
  var __index: number

  var __filter_keys: list<string>
  var __filter_name: string
  var __filter_index: number

  var __origin: number

  var __bufnr: number
  var __winid: number

  var __running: bool

  def new(
    items: list<string>,
    filters: dict<FilterFn> = {},
    actions: dict<ActionFn> = {},
  )
    this.__items = items
    this.__filters = extendnew(DEFAULT_FILTERS, filters)
    this.__actions = extendnew(DEFAULT_ACTIONS, actions)

    this.__query = ''
    this.__matches = []

    this.__offset = 0
    this.__index = 0

    this.__filter_keys = keys(this.__filters)
    sort(this.__filter_keys)

    if has_key(this.__filters, 'fuzzy')
      this.__filter_name = 'fuzzy'
      this.__filter_index = index(this.__filter_keys, 'fuzzy')
    else
      this.__filter_name = this.__filter_keys[0]
      this.__filter_index = 0
    endif

    this.__origin = -1

    this.__bufnr = -1
    this.__winid = -1

    this.__running = false
  enddef

  def Open(): void
    this.__origin = win_getid()
    this.__bufnr = bufadd('')

    bufload(this.__bufnr)
    setbufvar(this.__bufnr, '&bufhidden', 'wipe')
    setbufvar(this.__bufnr, '&buftype', 'nofile')
    setbufvar(this.__bufnr, '&swapfile', false)

    execute('silent botright split | resize ' .. this.HEIGHT)
    execute('buffer ' .. this.__bufnr)

    setlocal nonu nornu cul nowrap wfh

    this.__winid = win_getid()
    this.__running = true
    this.__Filter()
    this.__Loop()
  enddef

  def Close(): void
    this.__running = false

    if win_id2win(this.__winid) > 0
      win_execute(this.__winid, 'close')
    endif

    if win_id2win(this.__origin) > 0
      win_gotoid(this.__origin)
    endif

    redraw
  enddef

  def Next(): void
    if this.__index < len(this.__matches) - 1
      this.__index += 1

      if this.__index >= this.__offset + this.HEIGHT
        this.__offset += 1
      endif

      this.__Draw()
    endif
  enddef

  def Prev(): void
    if this.__index > 0
      this.__index -= 1

      if this.__index < this.__offset
        this.__offset -= 1
      endif

      this.__Draw()
    endif
  enddef

  def Cycle(): void
    this.__filter_index = (this.__filter_index + 1) % len(this.__filter_keys)
    this.__filter_name = this.__filter_keys[this.__filter_index]
    this.__Filter()
  enddef

  def Pop(): void
    if len(this.__query) > 0
      this.__query = this.__query[: -2]
      this.__Filter()
    endif
  enddef

  def Item(): string
    if this.__index < len(this.__matches)
      return this.__matches[this.__index]
    endif

    return ''
  enddef

  def Query(): string
    return this.__query
  enddef

  def __Draw(): void
    if win_id2win(this.__winid) == 0
      this.__running = false
      return
    endif

    deletebufline(this.__bufnr, 1, '$')

    if !empty(this.__matches)
      var vitems = this.__matches[this.__offset : this.__offset + this.HEIGHT - 1]
      setbufline(this.__bufnr, 1, vitems)

      var cursor = (this.__index - this.__offset) + 1
      win_execute(this.__winid, 'call cursor(' .. cursor .. ', 1)')
    endif

    var len = len(this.__matches)
    var pos = min([this.__index + 1, len])
    var status = printf(' %d/%d [%s]', pos, len, this.__filter_name)
    setwinvar(this.__winid, '&statusline', status)

    redraw | echo '> ' .. this.__query
  enddef

  def __Filter(): void
    const Fn = this.__filters[this.__filter_name]
    this.__matches = Fn(this.__items, this.__query)
    this.__offset = 0
    this.__index = 0
    this.__Draw()
  enddef

  def __Loop(): void
    try
      while this.__running
        var char = getcharstr()
        var char_n = char2nr(char)

        if has_key(this.__actions, char)
          this.__actions[char](this)
        elseif char_n >= 32 && char_n < 127
          this.__query ..= char
          this.__Filter()
        endif
      endwhile
    finally
      if this.__running
        this.Close()
      endif
    endtry
  enddef
endclass
