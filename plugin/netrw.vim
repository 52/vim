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

# Disable the netrw directory banner.
g:netrw_banner = 0

# Set the netrw history file location.
g:netrw_home = $XDG_DATA_HOME .. '/vim'
