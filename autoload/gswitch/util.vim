let s:save_cpo = &cpo
set cpo&vim

function! gswitch#util#echoerr(msg) abort
  echohl ErrorMsg
  echomsg 'vim-gswitch:' a:msg
  echohl None
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
