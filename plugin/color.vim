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

colorscheme foot

# Print the highlight group under the cursor.
# See: https://vim.fandom.com/wiki/Showing_syntax_highlight_group_in_statusline
def HlGroup(): void
  const synid = synID(line('.'), col('.'), 1)
  const name = synIDattr(synid, 'name')

  if empty(name)
    echohl WarningMsg | echo 'No highlight group' | echohl None
    return
  endif

  echo 'Group: ' .. name
enddef

# Print the highlight group chain under the cursor.
# See: http://vim.wikia.com/wiki/VimTip99
def HlTrace(): void
  const synid = synID(line('.'), col('.'), 1)
  const name = synIDattr(synid, 'name')

  if empty(name)
    echohl WarningMsg | echo 'No highlight group' | echohl None
    return
  endif

  const trans = synIDattr(synID(line('.'), col('.'), 0), 'name')
  const link = synIDattr(synIDtrans(synid), 'name')

  if name !=# trans
    echo printf('HlTrace: %s -> %s -> %s', name, trans, link)
  elseif name !=# link
    echo printf('HlTrace: %s -> %s', name, link)
  else
    echo 'Trace: ' .. name
  endif
enddef

command! HlGroup HlGroup()
command! HlTrace HlTrace()
