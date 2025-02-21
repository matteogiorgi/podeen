" plug.vim: simple viml-script that sets basic configuration
" for installed plugins (Vim 9.0+ required just for copilot).
" ---
" Ctrlp*     -> https://github.com/ctrlpvim/ctrlp.vim
" Copilot*   -> https://github.com/github/copilot.vim
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
function! s:Black()
    silent! execute '!black % 2>/dev/null'
    redraw!|redrawstatus!|redrawtabline
endfunction
" ---
augroup python_cmd
    autocmd!
    autocmd Filetype python command! -nargs=0 Black call <SID>Black()
    autocmd Filetype python nnoremap <buffer> <leader>d :update<CR>:call <SID>Black()<CR>
augroup end
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
    nnoremap <leader>u :CtrlPChange<CR>
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
    " ---
    function! s:TogglePanel()
        for l:buf in filter(range(1, bufnr('$')), 'bufname(v:val) =~# "^copilot:///panel/"')
            let l:panelname = bufname(l:buf)
            silent! execute 'bwipe ' . l:buf
        endfor
        if !exists("l:panelname")
            silent! Copilot panel
        endif
    endfunction
    " ---
    augroup copilot_prettyfier
        autocmd!
        autocmd FileType copilot*
              \ setlocal nonu nornu|
              \ setlocal bufhidden=wipe|
              \ setlocal nobuflisted|
              \ setlocal cursorline
    augroup end
    " ---
    command! -nargs=0 TogglePanel call <SID>TogglePanel()
    " ---
    inoremap <silent><C-s> <Plug>(copilot-suggest)
    inoremap <silent><C-d> <Plug>(copilot-dismiss)
    inoremap <silent><C-h> <C-w>
    inoremap <silent><C-j> <Plug>(copilot-next)
    inoremap <silent><C-k> <Plug>(copilot-previous)
    inoremap <silent><script><expr> <C-l> copilot#AcceptWord("\<CR>")
    inoremap <silent><script><expr> <C-f> copilot#AcceptLine("\<CR>")
    nnoremap <leader>w :TogglePanel<CR>
endif
" }}}




" Sandwich {{{
if &rtp =~ 'sandwich'
    runtime macros/sandwich/keymap/surround.vim
endif
"}}}

" vim: fdm=marker:sw=2:sts=2:et
