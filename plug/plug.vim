" plug.vim
" --------
" Vim script containing extra settings,
" keymaps and few plugins configuration.




" Init {{{
if exists('g:plugme')
    finish
endif
let g:plugme = 1
"}}}




" Python {{{
function! s:Black() abort
    if !executable('black')
        echo 'black not found'
        return
    endif
    silent! update
    silent! execute '!black % 2>/dev/null'
    redraw!|redrawstatus!|redrawtabline
endfunction
" ---
augroup python_cmd
    autocmd!
    autocmd Filetype python command! -nargs=0 Black call <SID>Black()
    autocmd Filetype python nnoremap <buffer> <leader>d :Black<CR>
    autocmd FileType python nnoremap <buffer> <leader>x :Black|ExecScript python3<CR>
    autocmd FileType python nnoremap <buffer> <leader>x :<C-U>ExecSnippet python3<CR>
augroup end
" }}}




" Ctrlp {{{
if &rtp =~ 'ctrlp'
    let g:ctrlp_map = ''
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_show_hidden = 0
    let g:ctrlp_custom_ignore = {
          \      'dir': '\v[\/]\.(git|hg|svn|mypy_cache)$',
          \      'file': '\v\.(exe|so|dll)$'
          \ }
    " ---
    augroup netrw_prettyfier
        autocmd FileType netrw
              \ if g:loaded_ctrlp == 1|
              \     nmap <buffer> <leader>f :CtrlP<space>%:p:h<CR>|
              \ endif
    augroup end
    " ---
    nnoremap <leader>u :CtrlPQuickfix<CR>
    nnoremap <leader>i :CtrlPChangeAll<CR>
    nnoremap <leader>f :CtrlP<space>%:p:h<CR>
    nnoremap <leader>h :CtrlPMRUFiles<CR>
    nnoremap <leader>j :CtrlPBuffer<CR>
    nnoremap <leader>k :CtrlPTag<CR>
    nnoremap <leader>l :CtrlPLine<CR>
endif
" }}}




" Sandwich {{{
if &rtp =~ 'sandwich'
    runtime macros/sandwich/keymap/surround.vim
endif
"}}}

" vim: fdm=marker:sw=2:sts=2:et
