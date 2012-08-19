" --------------- ------------------------------------------------------------
"           Name : vimshell
"       Synopsis : quickrun: runner/vimshell Runs by vimshell Popup windows
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : [TODO]( HomePage ) 
"        Version : 0.1
"   Date Created : Sun 19 Aug 2012 03:19:22 PM EDT
"  Last Modified : Sun 19 Aug 2012 03:20:21 PM EDT
"            Tag : [ vim, shell, runner ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------
let s:save_cpo = &cpo
set cpo&vim

let s:runner = {}

function! s:runner.run(commands, input, session)
  if a:cmd =~# '^\s*:'
    " A vim command.
    try
      let result = quickrun#execute(a:cmd)
    catch
      return ['', 1]
    endtry
    return [result, 0]
  endif

  let code = 0
  try
    VimShellPop
  catch /.*/
    call g:quickrun#V.print_error("fail to activate vimshell:" . v:exception)
    let code = 1
    return code
  endtry

  for cmd in a:commands
    execute "VimShellSendString " . cmd
  endfor
  return code
endfunction



function! quickrun#runner#vimshell#new()
  return deepcopy(s:runner)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
