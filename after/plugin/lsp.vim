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

if !exists('g:loaded_lsp')
  finish
endif

# LSP configuration options.
# See: https://github.com/yegappan/lsp/blob/main/doc/lsp.txt
const OPTIONS: dict<any> = {
  autoComplete: false,
  hoverInPreview: true,
}

# LSP server definition.
# Servers without an available executable are filtered.
# See: https://github.com/yegappan/lsp/blob/main/doc/configs.md
const SERVERS = [
  {
    name: 'nixd',
    filetype: ['nix'],
    path: 'nixd',
    args: []
  },
  {
    name: 'rust-analyzer',
    filetype: ['rust'],
    path: 'rust-analyzer',
    args: [],
    syncInit: true
  },
  {
    name: 'typescript-language-server',
    filetype: ['javascript', 'typescript'],
    path: 'typescript-language-server',
    args: ['--stdio']
  },
  {
    name: 'ty',
    filetype: ['python'],
    path: 'ty',
    args: ['server']
  }
]->filter((_, s) => executable(s.path))

# Registers the LSP servers with the yegappan/lsp plugin.
# Note: Uses deep copies as the plugin modifies arguments in place.
g:LspOptionsSet(deepcopy(OPTIONS))
g:LspAddServer(deepcopy(SERVERS))

augroup LspSetup
  autocmd!
  autocmd User LspAttached {
    nnoremap <buffer> <leader>R <cmd>LspRename<cr>
    nnoremap <buffer> <leader>H <cmd>LspHover<cr>
    nnoremap <buffer> <leader>ds <cmd>LspDiagShow<cr>
    nnoremap <buffer> <leader>dh <cmd>LspDiagHere<cr>
    nnoremap <buffer> <leader>de <cmd>LspGotoDeclaration<cr>
    nnoremap <buffer> <leader>df <cmd>LspGotoDefinition<cr>
    nnoremap <buffer> <leader>sr <cmd>LspShowReferences<cr>
    nnoremap <buffer> <leader>ss <cmd>LspShowSignature<cr>
  }
augroup END
