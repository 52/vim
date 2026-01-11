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

# Skip execution when the override variable is set.
if !empty(getenv('VIM_OVERRIDE_XDG'))
  finish
endif

# Sets the environment variable to ~/.cache if not already defined.
# Conforms to the XDG Base Directory Specification.
if empty(getenv('XDG_CACHE_HOME'))
  setenv('XDG_CACHE_HOME', expand('~/.cache'))
endif

# Sets the environment variable to ~/.config if not already defined.
# Conforms to the XDG Base Directory Specification.
if empty(getenv('XDG_CONFIG_HOME'))
  setenv('XDG_CONFIG_HOME', expand('~/.config'))
endif

# Sets the environment variable to ~/.local/state if not already defined.
# Conforms to the XDG Base Directory Specification.
if empty(getenv('XDG_STATE_HOME'))
  setenv('XDG_STATE_HOME', expand('~/.local/state'))
endif

# Sets the environment variable to ~/.local/share if not already defined.
# Conforms to the XDG Base Directory Specification.
if empty(getenv('XDG_DATA_HOME'))
  setenv('XDG_DATA_HOME', expand('~/.local/share'))
endif

# Map of options to XDG-compliant paths.
const PATHS: dict<dict<any>> = {
  backupdir: { type: 'dir', path: '$XDG_DATA_HOME/vim/backup' },
  directory: { type: 'dir', path: '$XDG_DATA_HOME/vim/swap' },
  undodir: { type: 'dir', path: '$XDG_DATA_HOME/vim/undo' },
  viewdir: { type: 'dir', path: '$XDG_DATA_HOME/vim/view' },
  viminfofile: { type: 'file', path: '$XDG_DATA_HOME/vim/viminfo' },
}

for [key, value] in items(PATHS)
  var path = expand(value.path)

  # Create directories when needed.
  if !isdirectory(path) && value.type == 'dir'
    mkdir(path, 'p')
  endif

  # Assign each path to its corresponding Vim option.
  execute 'set ' .. key .. '=' .. fnameescape(path)
endfor
