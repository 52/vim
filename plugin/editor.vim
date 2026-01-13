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

filetype plugin indent on
syntax enable

g:mapleader = ','
g:maplocalleader = ','

set number
set cursorline
set relativenumber
set nowrap

autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline

set autoindent

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set backspace=indent,eol,start
set iskeyword+=-

set hlsearch
set incsearch
set smartcase
set ignorecase

set foldmethod=manual
set foldlevelstart=10
set foldnestmax=10
set foldcolumn=1

set complete=.,w,b,u
set completepopup=highlight:Pmenu,border:off
set completeopt=menuone,popup,fuzzy,noinsert,noselect
set pumwidth=32
set pumheight=8

set laststatus=2
&statusline = ' %t %m%=%y '

set splitright
set splitbelow

set scrolloff=20

set backup
set swapfile
set undofile
set undolevels=10000
set undoreload=10000

set lazyredraw
set updatetime=100
set timeoutlen=500

set diffopt+=iwhite
set diffopt+=indent-heuristic
set diffopt+=algorithm:histogram

set autoread

set shortmess+=I

g:netrw_banner = 0
g:netrw_mousemaps = 0
g:netrw_dirhistmax = 0

if has('clipboard')
  set clipboard=unnamed

  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif
