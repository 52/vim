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

import autoload 'find.vim'

# Disable the command-line window.
nnoremap q: <nop>
nnoremap q/ <nop>
nnoremap q? <nop>

# Disable the antiquated Ex mode.
# In a sane world this wouldn't exist.
nnoremap Q <nop>

# Define the :Find command to access finder utilities.
command! -nargs=1 -complete=customlist,find.Complete Find find.Run(<f-args>)
nnoremap <leader>ff <cmd>Find files<cr>
nnoremap <leader>fg <cmd>Find git_files<cr>
