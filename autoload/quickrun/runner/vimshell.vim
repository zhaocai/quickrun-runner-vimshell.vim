" --------------- ------------------------------------------------------------
"           Name : vimshell
"       Synopsis : quickrun: runner/vimshell Runs by vimshell Popup windows
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/quickrun-runner-vimshell.vim
"        Version : 0.1
"   Date Created : Sun 19 Aug 2012 03:19:22 PM EDT
"  Last Modified : Sun 19 Aug 2012 06:36:02 PM EDT
"            Tag : [ vim, shell, runner ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------
let s:save_cpo = &cpo
set cpo&vim

let s:runner = {}

function! s:runner.init(session)
    let a:session.config.outputter = 'null'
endfunction

function! s:runner.run(commands, input, session)
    let ret = 0
    try
        VimShellPop
    catch /.*/
        let ret = 1
        call g:quickrun#V.print_error("fail to activate vimshell:" . v:exception)
        return ret
    endtry

    for cmd in a:commands
        if cmd =~# '^\s*:'
            " A vim command.
            try
                execute cmd
            catch
                break
            endtry
            continue
        endif

        call s:execute(cmd)
    endfor
    return ret
endfunction

function! s:execute(cmd)
    execute "VimShellSendString " . a:cmd
endfunction


function! quickrun#runner#vimshell#new()
    return deepcopy(s:runner)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" __MODELINE__  [[[1 ---------------------------------------------------------
"/!
" vim: set ft=vim et ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
