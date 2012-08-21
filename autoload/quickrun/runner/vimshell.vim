" --------------- ------------------------------------------------------------
"           Name : vimshell
"       Synopsis : quickrun: runner/vimshell Runs by vimshell Popup windows
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/quickrun-runner-vimshell.vim
"        Version : 0.1
"   Date Created : Sun 19 Aug 2012 03:19:22 PM EDT
"  Last Modified : Tue 21 Aug 2012 07:58:58 AM EDT
"            Tag : [ vim, shell, runner ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------
let s:save_cpo = &cpo
set cpo&vim

let s:runner = {
\   'config': {
\     'split': 'pop',
\   }
\ }

let s:vimshell_open = {
            \  'pop' : 'VimShellPop' ,
            \  'win' : 'VimShell'    ,
            \  'tab' : 'VimShellTab' ,
        \}
fun! s:map_vimshell_cmd(split)
    if has_key(s:vimshell_open, a:split)
        return s:vimshell_open[a:split]
    else
        call g:quickrun#V.print_error(a:split.":valid split option are [".join(keys(s:vimshell_open), ', ') . ']' )
        return s:vimshell_open['pop']
    endif
endf
fun! s:runner.init(session)
    let a:session.config.outputter = 'null'
endf

fun! s:runner.run(commands, input, session)
    let ret = 0
    try
        execute s:map_vimshell_cmd(self.config.split)
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
endf

fun! s:runner.shellescape(str)
  return '"' . escape(a:str, '\"') . '"'
endf

fun! s:execute(cmd)
    try
        execute "VimShellSendString " . a:cmd
    catch /.*/
        call g:quickrun#V.print_error("fail to send command to vimshell:" . v:exception)
    endtry

endf


fun! quickrun#runner#vimshell#new()
    return deepcopy(s:runner)
endf

let &cpo = s:save_cpo
unlet s:save_cpo

" __MODELINE__  [[[1 ---------------------------------------------------------
"/!
" vim: set ft=vim et ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
