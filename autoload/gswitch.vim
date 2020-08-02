let s:save_cpo = &cpo
set cpo&vim

" TODO:
" * エラー処理
" * テスト
" * document

function! gswitch#init_buf() abort
  let t:gswitch_bufnr = nvim_create_buf(v:false, v:true)
  let branches = [
    \ 'Search: ',
    \ '+ Create a new branch...',
    \ ]
  let branches = branches + split(system('git branch'), "\n")
  call nvim_buf_set_lines(t:gswitch_bufnr, 0, -1, v:true, branches)
endfunction

function! gswitch#close_buf() abort
  execute printf("bwipeout! %d", t:gswitch_bufnr)
  unlet t:gswitch_bufnr
  unlet t:gswitch_winnr
endfunction

function! gswitch#open_win() abort
  let opts = {
    \ 'relative': 'editor',
    \ 'width': &columns / 3,
    \ 'height': min([len(getbufline(t:gswitch_bufnr, "1", "$")), 8]),
    \ 'col': &columns / 3,
    \ 'row': 0,
    \ 'anchor': 'NW',
    \ 'style': 'minimal'
    \ }
  let t:gswitch_winnr = nvim_open_win(t:gswitch_bufnr, v:true, opts)
  startinsert!
  setlocal cursorline
  call gswitch#set_mapping()
endfunction

function! gswitch#set_mapping() abort
  nnoremap <buffer><silent> q :<C-u>call gswitch#close_buf()<CR>
  inoremap <buffer><silent> <C-c> <Esc>:<C-u>call gswitch#close_buf()<CR>

  nnoremap <buffer><silent> <CR> :call gswitch#on_selected()<CR>
  inoremap <buffer><silent> <CR> <Esc>:call gswitch#on_selected()<CR>

  inoremap <buffer> <C-n> <Down>
  inoremap <buffer> <C-p> <Up>
endfunction

function! gswitch#open() abort
  if !executable('git')
    call gswitch#util#echoerr('git is not installed.')
    return
  endif

  if !gswitch#git#is_repository()
    " FIXME: エラー表示のあとカーソルが消える（起動直後に実行した場合）
    call gswitch#util#echoerr('not a git repository.')
    return
  endif

  call gswitch#init_buf()
  call gswitch#open_win()
endfunction

function! gswitch#on_selected() abort
  let lnum = line(".")
  if lnum == 1
    call gswitch#update_list()
  elseif lnum == 2
    call gswitch#show_create_wizard()
  else
    call gswitch#git#switch_branch()
  endif
endfunction

function! gswitch#update_list() abort
  let lines = getbufline(t:gswitch_bufnr, "1", "$")
  let search_text = substitute(lines[0], 'Search: ', '', 'g')
  let filtered = lines[:1] + filter(lines[2:], {i, v -> v =~ search_text })
  call nvim_buf_set_lines(t:gswitch_bufnr, 0, -1, v:true, filtered)
  call cursor(3, 1)
endfunction

function! gswitch#show_create_wizard() abort
  call gswitch#show_prompt('Branch name: ')
  inoremap <buffer> <CR> <Esc>:call gswitch#git#create_branch()<CR>
endfunction

function! gswitch#show_prompt(msg) abort
  call nvim_buf_set_lines(t:gswitch_bufnr, 0, -1, v:true, [a:msg])
  call nvim_win_set_height(t:gswitch_winnr, 1)
  startinsert!
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
