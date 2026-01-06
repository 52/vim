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

# Enable insert mode completions.
set autocomplete

# Set the completion popup highlight group.
set completepopup=highlight:Pmenu

# Display the menu for a single candidate.
set completeopt=menuone

# Display extra information about the current candidate.
set completeopt+=popup

# Enable fuzzy-matching for candidates.
set completeopt+=fuzzy

# Disable automatic candidate insertion.
set completeopt+=noinsert

# Disable automatic candidate selection.
set completeopt+=noselect

# Register the completion sources.
set complete=.

# Limit the number of candidates to n.
set pumheight=6
