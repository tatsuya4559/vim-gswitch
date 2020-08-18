let s:save_cpo = &cpo
set cpo&vim

function! gswitch#git#is_repository() abort
  return !empty(system('git rev-parse --git-dir 2>/dev/null'))
endfunction

function! gswitch#git#do_checkout(branch, options) abort
  let msg = system('git checkout ' . join(a:options) . ' ' . a:branch)
  if v:shell_error != 0
    return trim(msg)
  endif
  return ''
endfunction

function! gswitch#git#create_branch() abort
  let branch = split(trim(getline(".")))[-1]
  let err = gswitch#git#do_checkout(branch, ['-b'])
  if err != ''
    call gswitch#util#echoerr(err)
  else
    echo 'Created a new branch: ' . branch
  endif
  call gswitch#close_buf()
  checktime
endfunction

function! gswitch#git#switch_branch() abort
  let branch = split(trim(getline(".")))[-1]
  let err = gswitch#git#do_checkout(branch, [])
  if err != ''
    call gswitch#util#echoerr(err)
  else
    echo 'Switched to ' . branch
  endif
  call gswitch#close_buf()
  checktime
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
