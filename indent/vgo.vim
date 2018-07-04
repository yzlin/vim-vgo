" Copyright The vgo Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal autoindent
setlocal indentexpr=VgoIndent(v:lnum)
setlocal indentkeys+=0=)

if exists("*VgoIndent")
  finish
endif

" use shiftwidth function only if it's available
if exists('*shiftwidth')
  func s:sw()
    return shiftwidth()
  endfunc
else
  func s:sw()
    return &sw
  endfunc
endif

function! VgoIndent(lnum)
  let prevlnum = prevnonblank(a:lnum-1)
  if prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let prevl = substitute(getline(prevlnum), '//.*$', '', '')
  let thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let previ = indent(prevlnum)

  let ind = previ

  if prevl =~ '[(]\s*$'
    " previous line opened a block
    let ind += s:sw()
  endif
  if thisl =~ '^\s*[)]'
    " this line closed a block
    let ind -= s:sw()
  endif

  return ind
endfunction

" vim: sts=2:sw=2:ts=2:et
