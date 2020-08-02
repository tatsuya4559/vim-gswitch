let s:save_cpo = &cpo
set cpo&vim

function! gswitch#git#is_repository() abort
  return !empty(system('git rev-parse --git-dir 2>/dev/null'))
endfunction

function! gswitch#git#do_checkout(branch, options) abort
  let msg = system('git checkout ' . join(a:options) . ' ' . a:branch)
  let status_code = system('echo $?')
  if status_code != 0
    call gswitch#util#echoerr(msg)
  endif
  call gswitch#close_buf()
  checktime
endfunction

function! gswitch#git#create_branch() abort
  let branch = split(trim(getline(".")))[-1]
  call gswitch#git#do_checkout(branch, ['-b'])
  echo 'Created a new branch: ' . branch
endfunction

function! gswitch#git#switch_branch() abort
  " TODO: checkoutできなかったときの処理
  let branch = split(trim(getline(".")))[-1]
  call gswitch#git#do_checkout(branch, [])
  echo 'Switched to ' . branch
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
