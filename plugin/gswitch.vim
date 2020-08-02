if exists('g:loaded_gswitch')
  finish
endif
let g:loaded_gswitch = 1

let s:save_cpo = &cpo
set cpo&vim

" コマンド定義

nnoremap <silent> <Plug>(gswitch-open) :<C-u>call gswitch#open()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
