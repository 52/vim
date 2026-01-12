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

import autoload 'insel.vim'

# Interactive file finder using INSEL.
# Attempts to locate files using external commands in order:
# fd, find or Vim's built-in recursive globbing as fallback.
export def Files(): void
  var items: list<string>

  if executable('fd')
    items = systemlist('fd -tf -H 2>/dev/null')
  elseif executable('find')
    items = systemlist('find . -type f 2>/dev/null')
  else 
    items = glob('**/*', false, true)
  endif

  var i = insel.Insel.new(items, {}, {
    "\<CR>": (i) => {
      const item = i.Item()
      i.Close()

      if !empty(item)
        execute('edit ' .. fnameescape(item))
      endif
      }
  })

  i.Open()
enddef

# Interactive file finder using INSEL (git-aware).
# Lists tracked and untracked files while respecting .gitignore.
export def GFiles(): void
  var items: list<string>

  if executable('git')
    items = systemlist('git ls-files -co --exclude-standard 2>/dev/null')
  elseif executable('fd')
    items = systemlist('fd -tf -H -E .git 2>/dev/null')
  endif

  var i = insel.Insel.new(items, {}, {
    "\<CR>": (i) => {
      const item = i.Item()
      i.Close()

      if !empty(item)
        execute('edit ' .. fnameescape(item))
      endif
      }
  })

  i.Open()
enddef

# Dictionary mapping command identifiers to their implementation.
# Used by the Run() function to dispatch commands dynamically.
const REGISTRY: dict<func(): void> = {
  'files': Files,
  'git_files': GFiles,
}

# Generates completion candidates for the :Find command.
# See: https://vimhelp.org/map.txt.html#%3Acommand-completion-customlist
export def Complete(arg: string, line: string, pos: number): list<string>
  return keys(REGISTRY)->filter((_, v) => v =~ '^' .. arg)
enddef

# Executes the command implementation.
export def Run(arg: string): void
  if has_key(REGISTRY, arg)
    REGISTRY[arg]()
  else
    echoerr 'Unknown command: ' .. arg
  endif
enddef
