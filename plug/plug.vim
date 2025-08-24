" plug.vim: simple viml-script that sets basic configuration
" for the following plugins (Vim 9.0+ is preferred).
" ---
" Ctrlp*     -> https://github.com/ctrlpvim/ctrlp.vim
" Sandwich*  -> https://github.com/machakann/vim-sandwich
" Commentary -> https://github.com/tpope/vim-commentary
" Lexima     -> https://github.com/cohama/lexima.vim
" Context    -> https://github.com/wellle/context.vim




" Init {{{
if exists("g:plugme")
    finish
endif
let g:plugme = 1
"}}}




" Python {{{
if executable('python3')
    function! s:ExecPF()
        silent! update
        execute '!python3 %'
    endfunction
    " ---
    function! s:ExecPS()
        let l:tmpfile = tempname()
        silent! execute "'<,'>write " . l:tmpfile
        execute '!python3 ' . l:tmpfile
    endfunction
    " ---
    augroup python_cmd
        autocmd!
        autocmd Filetype python nnoremap <buffer> <leader>x :call <SID>ExecPF()<CR>
        autocmd Filetype python vnoremap <buffer> <leader>x :<C-U>call <SID>ExecPS()<CR>
    augroup end
endif
" ---
if executable('black')
    function! s:Black()
        silent! update
        silent! execute '!black % 2>/dev/null'
        redraw!|redrawstatus!|redrawtabline
    endfunction
    " ---
    augroup python_cmd
        autocmd Filetype python command! -nargs=0 Black call <SID>Black()
        autocmd Filetype python nnoremap <buffer> <leader>d :call <SID>Black()<CR>
    augroup end
endif
" }}}




" Ctrlp {{{
if &rtp =~ 'ctrlp'
    let g:ctrlp_map = ''
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_show_hidden = 1
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
    nnoremap <leader>i :CtrlPMixed<CR>
    nnoremap <leader>o :CtrlPChangeAll<CR>
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
