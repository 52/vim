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

# Set the XDG_CACHE_HOME environment variable if not defined.
# See: https://specifications.freedesktop.org/basedir-spec/latest/
if empty(getenv('XDG_CACHE_HOME'))
  setenv('XDG_CACHE_HOME', expand('~/.cache'))
endif

# Set the XDG_CONFIG_HOME environment variable if not defined.
# See: https://specifications.freedesktop.org/basedir-spec/latest/
if empty(getenv('XDG_CONFIG_HOME'))
  setenv('XDG_CONFIG_HOME', expand('~/.config'))
endif

# Set the XDG_STATE_HOME environment variable if not defined.
# See: https://specifications.freedesktop.org/basedir-spec/latest/
if empty(getenv('XDG_STATE_HOME'))
  setenv('XDG_STATE_HOME', expand('~/.local/state'))
endif

# Set the XDG_DATA_HOME environment variable if not defined.
# See: https://specifications.freedesktop.org/basedir-spec/latest/
if empty(getenv('XDG_DATA_HOME'))
  setenv('XDG_DATA_HOME', expand('~/.local/share'))
endif

# Enable filetype, plugins and indentation.
filetype plugin indent on

# Automatically reload files changed outside of vim.
set autoread

# Configure the leader key.
g:mapleader = ','
g:maplocalleader = ','

# Enable absolute line numbers.
set number

# Enable relative line numbers.
set relativenumber

# Enable the cursorline.
set cursorline

# Disable the signcolumn.
set signcolumn=no

# Configure search behaviour.
set ignorecase
set smartcase
set incsearch
set hlsearch

# Configure tabs and indentation.
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

# Disable automatic line wrapping.
set nowrap

# Enable automatic indentation.
set autoindent

# Keep 10 lines visible above and below cursor.
set scrolloff=10

# Split windows to the right and below.
set splitright
set splitbelow

# Disable folding behaviours.
set nofoldenable
set foldmethod=manual
set foldlevelstart=99

# Configure editing behaviour.
set backspace=indent,eol,start
set iskeyword+=-

# Enable automatic persistance files.
set backup
set swapfile
set undofile
set undolevels=10000
set undoreload=10000

# Configure XDG-compliant file locations.
set viminfofile=$XDG_DATA_HOME/vim/viminfo
set backupdir=$XDG_DATA_HOME/vim/backup// | mkdir(&backupdir, 'p')
set directory=$XDG_DATA_HOME/vim/swap//   | mkdir(&directory, 'p')
set undodir=$XDG_DATA_HOME/vim/undo//     | mkdir(&undodir, 'p')
set viewdir=$XDG_DATA_HOME/vim/view//     | mkdir(&viewdir, 'p')

# Improve performance and timing.
set lazyredraw
set updatetime=100
set timeoutlen=500

# Configure sane diff mode options.
set diffopt+=iwhite
set diffopt+=indent-heuristic
set diffopt+=algorithm:histogram

# Configure the system clipboard.
if has('clipboard')
  set clipboard=unnamed

  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif
