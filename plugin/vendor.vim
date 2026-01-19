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

# Loads plugins from the vendor directory.
# Each subdirectory is treated as an individual plugin.
#
# Plugins are processed in the following order:
#
# 1. Add the root and '/after' path to the runtimepath.
# 2. Source ftdetect/*.vim for filetype detection.
# 3. Source plugin/**/*.vim for plugin scripts.
# 4. Source after/plugin/**/*.vim for after scripts.
# 5. Generate the helptags files.
#
# Helptags are generated at runtime by symlinking the documentation to TMP.
# This avoids writes to a potentially read-only vendor directory.

# Absolute path to the vendor directory.
const ROOT = expand('<script>:p:h:h') .. '/vendor'

# Absolute path to the temporary directory.
# Includes the username and process ID to prevent collisions.
const TMP = '/tmp/vim-' .. $USER .. '-' .. getpid()

# Remove the temporary directory on VimLeave.
execute 'autocmd VimLeave * ++once delete("' .. TMP .. '", "rf")'

if isdirectory(ROOT)
  for path in glob(ROOT .. '/*', true, true)
    if isdirectory(path)
      # Prepend root to runtimepath.
      execute('set runtimepath^=' .. fnameescape(path))

      # Append /after to runtimepath.
      var pafter = path .. '/after'
      if isdirectory(pafter)
        execute('set runtimepath+=' .. fnameescape(pafter))
      endif

      # Source the /ftdetect scripts.
      for file in glob(path .. '/ftdetect/*.vim', true, true)
        execute('source ' .. fnameescape(file))
      endfor

      # Source the /plugin scripts.
      for file in glob(path .. '/plugin/**/*.vim', true, true)
        execute('source ' .. fnameescape(file))
      endfor

      # Source the /after/plugin scripts.
      for file in glob(path .. '/after/plugin/**/*.vim', true, true)
        execute('source ' .. fnameescape(file))
      endfor

      # Generate the helptags.
      var pdoc = path .. '/doc'
      if isdirectory(pdoc)
        var ptmp = TMP .. '/' .. fnamemodify(path, ':t')
        var ptmpdoc = ptmp .. '/doc'

        if isdirectory(ptmp)
          delete(ptmp, 'rf')
        endif

        mkdir(ptmpdoc, 'p')

        # Symlink plugin documentation to the directory.
        for file in glob(pdoc .. '/*.txt', true, true)
          silent! system('ln -sf ' .. shellescape(file) .. ' ' .. shellescape(ptmpdoc))
        endfor

        try
          execute('silent helptags ' .. fnameescape(ptmpdoc))
        catch
        endtry

        # Append directory to runtimepath.
        if filereadable(ptmpdoc .. '/tags')
          execute('set runtimepath+=' .. fnameescape(ptmp))
        endif
      endif
    endif
  endfor
endif
