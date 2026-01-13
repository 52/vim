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
]->filter((_, s) => executable(s.path))

# Registers the LSP servers with the yegappan/lsp plugin.
# Note: Uses deep copies as the plugin modifies arguments in place.
g:LspOptionsSet(deepcopy(OPTIONS))
g:LspAddServer(deepcopy(SERVERS))
