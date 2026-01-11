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

hi clear

if has('termguicolors')
  set notermguicolors
endif

if exists("syntax on")
  syntax reset
endif

g:colors_name = "foot"
set background=dark

############ USER-INTERFACE ############

highlight Normal ctermbg=NONE ctermfg=NONE
highlight link Terminal Normal

# Cursor
# CursorIM
# lCursor

highlight Visual    ctermbg=8 ctermfg=NONE cterm=NONE
highlight VisualNOS ctermbg=8 ctermfg=NONE cterm=NONE

highlight Search    ctermbg=8 ctermfg=NONE
highlight CurSearch ctermbg=8 ctermfg=NONE cterm=bold,underline
highlight IncSearch ctermbg=8 ctermfg=NONE cterm=bold,underline

highlight MatchParen ctermbg=0 ctermfg=11 cterm=bold
highlight link QuickFixLine Search

highlight LineNr ctermbg=NONE ctermfg=8 cterm=NONE
highlight link LineNrAbove LineNr
highlight link LineNrBelow LineNr

highlight CursorLine     ctermfg=NONE ctermbg=0 cterm=NONE
highlight CursorLineNr   ctermfg=NONE ctermbg=0 cterm=NONE
highlight CursorLineSign ctermfg=NONE ctermbg=0 cterm=NONE
highlight link CursorLineFold FoldColumn

highlight StatusLine   cterm=reverse
highlight StatusLineNC cterm=reverse
# StatusLineTerm
# StatusLineTermNC

# TabLine
# TabLineFill
# TabLineSel
# TabPanel
# TabPanelFill
# TabPanelSel

highlight VertSplit ctermbg=NONE ctermfg=0

highlight ColorColumn  ctermbg=0 
highlight CursorColumn ctermbg=0
highlight FoldColumn   ctermbg=NONE ctermfg=9
highlight SignColumn   ctermbg=NONE ctermfg=9

highlight Pmenu         ctermbg=0 ctermfg=8
highlight PmenuSel      ctermbg=8 ctermfg=15
highlight PmenuExtra    ctermbg=0 ctermfg=4
highlight PmenuExtraSel ctermbg=8 ctermfg=12
highlight PmenuKind     ctermbg=0 ctermfg=4
highlight PmenuKindSel  ctermbg=8 ctermfg=12
highlight PmenuMatch    ctermbg=0 ctermfg=3  cterm=bold
highlight PmenuMatchSel ctermbg=8 ctermfg=11 cterm=bold
highlight PmenuSbar     ctermbg=0 ctermfg=0
highlight PmenuThumb    ctermbg=0 ctermfg=0
# PmenuBorder
# PmenuShadow

# PopupSelected
# PopupNotification

# MessageWindow

highlight ErrorMsg   ctermbg=NONE ctermfg=1 cterm=NONE
highlight WarningMsg ctermbg=NONE ctermfg=3 cterm=NONE

highlight Question ctermbg=NONE ctermfg=11 cterm=NONE
highlight MoreMsg  ctermbg=NONE ctermfg=11 cterm=NONE

highlight MsgArea  ctermbg=NONE ctermfg=NONE cterm=NONE
highlight ModeMsg  ctermbg=NONE ctermfg=NONE cterm=NONE
highlight WildMenu ctermbg=3    ctermfg=0    cterm=NONE

highlight DiffAdd     ctermbg=NONE ctermfg=2  cterm=NONE
highlight DiffChange  ctermbg=NONE ctermfg=3  cterm=NONE
highlight DiffDelete  ctermbg=NONE ctermfg=1  cterm=NONE
highlight DiffText    ctermbg=0    ctermfg=11 cterm=underline
highlight DiffTextAdd ctermbg=0    ctermfg=10 cterm=underline

# SpellBad
# SpellCap
# SpellLocal
# SpellRare

highlight Conceal ctermbg=15 ctermfg=0 cterm=NONE
highlight Folded  ctermbg=0  ctermfg=8 cterm=NONE

highlight Directory ctermfg=4
highlight Title     ctermfg=3

highlight EndOfBuffer ctermbg=NONE ctermfg=8 cterm=NONE
highlight NonText     ctermbg=NONE ctermfg=8 cterm=NONE
highlight SpecialKey  ctermbg=NONE ctermfg=1 cterm=bold

############ LANGUAGE SYNTAX ############
if str2nr(&t_Co) == 256
  highlight Comment ctermfg=245

  # Constant
  # Boolean -> Constant
  # Character -> Constant
  # Float -> Constant
  # String -> Constant

  # Identifier
  # Function -> Identifier

  # Statement 
  # Conditional -> Statement
  # Exception -> Statement
  # Keyword -> Statement
  # Label -> Statement
  # Operator -> Statement
  # Repeat -> Statement

  # Type
  # StorageClass -> Type
  # Structure -> Type
  # Typedef -> Type

  # PreProc
  # Define -> PreProc
  # Include -> PreProc
  # Precondit -> PreProc
  # Macro -> PreProc

  # Special
  # SpecialChar
  # SpecialComment
  # Delimiter
  # Tag
  # Debug

  # Ignore
  # Error
  # Todo

  highlight Added   ctermbg=NONE ctermfg=2 cterm=NONE
  highlight Changed ctermbg=NONE ctermfg=3 cterm=NONE
  highlight Removed ctermbg=NONE ctermfg=1 cterm=NONE

  highlight diffFile      ctermbg=NONE ctermfg=NONE cterm=bold
  highlight diffoldFile   ctermbg=NONE ctermfg=NONE cterm=bold
  highlight diffnewFile   ctermbg=NONE ctermfg=NONE cterm=bold
  highlight diffIndexLine ctermbg=NONE ctermfg=NONE cterm=bold
  highlight diffLine      ctermbg=NONE ctermfg=6    cterm=NONE
  highlight diffSubname   ctermbg=NONE ctermfg=8    cterm=NONE
endif
