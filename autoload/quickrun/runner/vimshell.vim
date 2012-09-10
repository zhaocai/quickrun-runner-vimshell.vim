" --------------- ------------------------------------------------------------
"           Name : vimshell
"       Synopsis : quickrun: runner/vimshell Runs by vimshell Popup windows
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/quickrun-runner-vimshell.vim
"        Version : 0.1
"   Date Created : Sun 19 Aug 2012 03:19:22 PM EDT
"  Last Modified : Mon 10 Sep 2012 01:19:23 PM EDT
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
function! s:map_vimshell_cmd(split)
    if has_key(s:vimshell_open, a:split)
        return s:vimshell_open[a:split]
    else
        call g:quickrun#V.print_error(a:split.":valid split option are [".join(keys(s:vimshell_open), ', ') . ']' )
        return s:vimshell_open['pop']
    endif
endfunction
function! s:runner.init(session)
    let a:session.config.outputter = 'null'
endfunction

function! s:runner.run(commands, input, session)
    "    call Dfunc("vimshell_runner.run(" . string(a:) . ")")
    let ret = 0
    try
        let is_vimshell_visible = 0
        if exists('t:vimshell')
            let last_interactive_bufnr = t:vimshell.last_interactive_bufnr
            let winnr = bufwinnr(last_interactive_bufnr)
            if winnr > 0
                let is_vimshell_visible = 1
            endif
        endif
        if is_vimshell_visible == 0
            execute s:map_vimshell_cmd(self.config.split)
        endif
    catch /.*/
        let ret = 1
        call g:quickrun#V.print_error("fail to activate vimshell:" . v:exception)
        return ret
    endtry

    call s:execute(a:commands)

    "    call Dret('vimshell_runner.run')
    return ret
endfunction

function! s:runner.shellescape(str)
  return '"' . escape(a:str, '\"') . '"'
endfunction

function! s:execute(cmd)
    try
        call vimshell#interactive#send_string(a:cmd)
    catch /.*/
        call g:quickrun#V.print_error("fail to send command to vimshell:" . v:exception)
    endtry

endfunction


function! quickrun#runner#vimshell#new()
    return deepcopy(s:runner)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" __MODELINE__  [[[1 ---------------------------------------------------------
"/!
" vim: set ft=vim et ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
