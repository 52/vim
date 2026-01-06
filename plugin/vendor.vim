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

var root = expand('<script>:p:h:h') .. '/vendor'
if isdirectory(root)
  for path in glob(root .. '/*', true, true)
    if isdirectory(path)
      # Append the root path to the runtimepath.
      execute('set runtimepath+=' .. fnameescape(path))

      # Append the '/after' path to the runtimepath.
      var pafter = path .. '/after'
      if isdirectory(pafter)
        execute('set runtimepath+=' .. fnameescape(pafter))
      endif

      # Source all files in '/ftdetect'.
      for file in glob(path .. '/ftdetect/*.vim', true, true)
        execute('source ' .. fnameescape(file))
      endfor

      # Source all files in '/plugin'.
      for file in glob(path .. '/plugin/**/*.vim', true, true)
        execute('source ' .. fnameescape(file))
      endfor

      # Source all files in 'after/plugin'.
      for file in glob(path .. '/after/plugin/**/*.vim', true, true)
        execute('source ' .. fnameescape(file))
      endfor
    endif
  endfor
endif
