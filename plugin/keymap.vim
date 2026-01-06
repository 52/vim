""
"
" SPDX-License-Identifier: MIT
" Author: Max Karou <maxkarou@protonmail.com>
" URL: https://github.com/52/vix
"
"

if !has('vim9script')
  finish
endif

vim9script

# Disable the command-line window.
nnoremap q: <nop>
nnoremap q/ <nop>
nnoremap q? <nop>

# In a sane world this would not exist.
nnoremap Q <nop>
