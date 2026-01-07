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
