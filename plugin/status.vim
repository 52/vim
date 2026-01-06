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

# Enable the statusline.
set laststatus=2

# Reset the statusline.
set statusline=

# Display the buffer name.
set statusline+=\ %t

# Display the modification status.
set statusline+=\ %m

# Switch to right alignment.
set statusline+=%=

# Display the filetype.
set statusline+=%y\ 
