" plug.vim: simple viml-script that sets basic configuration
" for installed plugins (Vim 9.0+ required just for copilot).
" ---
" Sandwich*  -> https://github.com/machakann/vim-sandwich
" Commentary -> https://github.com/tpope/vim-commentary
" Lexima     -> https://github.com/cohama/lexima.vim
" Context    -> https://github.com/wellle/context.vim
" Signify*   -> https://github.com/mhinz/vim-signify
" Ctrlp*     -> https://github.com/ctrlpvim/ctrlp.vim
" Copilot*   -> https://github.com/github/copilot.vim




" Init {{{
if exists("g:plugme")
    finish
endif
let g:plugme = 1
"}}}




" Sandwich {{{
if &rtp =~ 'sandwich'
    runtime macros/sandwich/keymap/surround.vim
endif
"}}}




" Signify {{{
if &rtp =~ 'signify'
    nnoremap <silent><C-n> <plug>(signify-next-hunk)
    nnoremap <silent><C-p> <plug>(signify-prev-hunk)
endif
" }}}




" Ctrlp {{{
if &rtp =~ 'ctrlp'
    function! s:Ctags()
        if !executable('ctags')
            echo "ctags not installed"
            return
        endif
        execute 'silent !ctags -R --exclude=.git'
        redraw!|redrawstatus!|redrawtabline
        echo "ctags executed"
    endfunction
    " ---
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
    augroup ctags_onsave
        autocmd!
        autocmd BufWritePost *
              \ if filereadable('tags')|
              \     call <SID>Ctags()|
              \ endif
    augroup end
    " ---
    command! -nargs=0 Ctags call <SID>Ctags()
    nnoremap <leader>i :CtrlPQuickfix<CR>
    nnoremap <leader>f :CtrlP<space>%:p:h<CR>
    nnoremap <leader>h :CtrlPMRUFiles<CR>
    nnoremap <leader>j :CtrlPBuffer<CR>
    nnoremap <leader>k :CtrlPTag<CR>
    nnoremap <leader>l :CtrlPLine<CR>
endif
" }}}




" Copilot {{{
if &rtp =~ 'copilot'
    let g:copilot_enabled = v:false
    augroup copilot_prettyfier
        autocmd!
        autocmd FileType copilot*
              \ setlocal cursorline|
              \ setlocal nonu nornu|
              \ setlocal colorcolumn=|
              \ setlocal bufhidden=wipe|
              \ setlocal nobuflisted
    augroup end
    " ---
    inoremap <silent><C-s> <Plug>(copilot-suggest)
    inoremap <silent><C-d> <Plug>(copilot-dismiss)
    inoremap <silent><C-h> <C-w>
    inoremap <silent><C-j> <Plug>(copilot-next)
    inoremap <silent><C-k> <Plug>(copilot-previous)
    inoremap <silent><script><expr> <C-l> copilot#AcceptWord("\<CR>")
    inoremap <silent><script><expr> <C-f> copilot#AcceptLine("\<CR>")
endif
" }}}

" vim: fdm=marker:sw=2:sts=2:et
