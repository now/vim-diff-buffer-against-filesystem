" Vim plugin file
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2008-10-21

if exists('loaded_plugin_now_diff_buffer_against_filesystem')
  finish
endif
let loaded_plugin_now_diff_buffer_against_filesystem = 1

let s:cpo_save = &cpo
set cpo&vim

if !hasmapto('<Plug>diff_buffer_against_filesystem_open')
  nmap <unique> <Leader>df <Plug>diff_buffer_against_filesystem_open
endif

if !hasmapto('<Plug>diff_buffer_against_filesystem_close')
  nmap <unique> <Leader>dc <Plug>diff_buffer_against_filesystem_close
endif

nnoremap <unique> <script> <Plug>diff_buffer_against_filesystem_open <SID>diff_buffer_against_filesystem_open
nnoremap <silent> <SID>diff_buffer_against_filesystem_open <Esc>:call <SID>diff_buffer_against_filesystem_open()<CR>

nnoremap <unique> <script> <Plug>diff_buffer_against_filesystem_close <SID>diff_buffer_against_filesystem_close
nnoremap <silent> <SID>diff_buffer_against_filesystem_close <Esc>:call <SID>diff_buffer_against_filesystem_close()<CR>

command! DiffAgainstFilesystem call s:diff_buffer_against_filesystem_open()
command! DiffAgainstFilesystemClose call s:diff_buffer_against_filesystem_close()

function! s:diff_buffer_against_filesystem_open()
  if !&modified
    echohl WarningMsg | echo 'Buffer not modified' | echohl None
    return
  endif

  if exists('w:diff_buffer')
    return
  endif

  let file_buffer = winbufnr(0)

  let title = '[Diff] ' . expand('%')
  execute 'vertical rightbelow new' title
  let diff_buffer = winbufnr(0)
  set buftype=nofile bufhidden=wipe nobuflisted noswapfile modifiable
  read #
  0delete _

  set nomodifiable
  diffthis

  augroup plugin-now-diff-buffer-against-filesystem
    autocmd BufUnload <buffer> :diffoff!
  augroup end

  wincmd p
  diffthis

  augroup plugin-now-diff-buffer-against-filesystem
    autocmd BufWinLeave <buffer> call s:diff_buffer_against_filesystem_close_if_open()
  augroup end

  let w:diff_buffer = diff_buffer
endfunction

function! s:diff_buffer_against_filesystem_close_if_open()
  if exists('w:diff_buffer')
    call s:diff_buffer_against_filesystem_close()
    quit
  endif
endfunction

function! s:diff_buffer_against_filesystem_close()
  if !exists('w:diff_buffer')
    echohl Error | echo 'No diff associated with this buffer' | echohl None
    return
  endif

  execute w:diff_buffer . 'bdelete'

  unlet w:diff_buffer
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
