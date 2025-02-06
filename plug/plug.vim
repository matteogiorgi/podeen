" plug.vim: simple viml-script that sets basic configuration
" for installed plugins (Vim 9.0+ required just for copilot).
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
    nnoremap <leader>i :CtrlPQuickfix<CR>
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
