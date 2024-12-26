" plug.vim: simple viml-script that sets basic configuration
" for installed plugins (Vim 9.0+ required just for copilot).
" ---
" Commentary -> https://github.com/tpope/vim-commentary
" Surround   -> https://github.com/tpope/vim-surround
" Repeat     -> https://github.com/tpope/vim-repeat
" Lexima     -> https://github.com/cohama/lexima.vim
" Context    -> https://github.com/wellle/context.vim
" Signify*   -> https://github.com/mhinz/vim-signify
" Ale*       -> https://github.com/dense-analysis/ale
" Ctrlp*     -> https://github.com/ctrlpvim/ctrlp.vim
" Copilot*   -> https://github.com/github/copilot.vim




" Init {{{
if exists("g:plugme")
    finish
endif
let g:plugme = 1
"}}}




" Signify {{{
if &rtp =~ 'signify'
    nnoremap <silent><C-n> <plug>(signify-next-hunk)
    nnoremap <silent><C-p> <plug>(signify-prev-hunk)
    nnoremap <leader>g :SignifyDiff<CR>
    nnoremap <leader>v :SignifyHunkDiff<CR>
    nnoremap <leader>b :SignifyHunkUndo<CR>
endif
" }}}




" Ale {{{
if &rtp =~ 'ale'
    function! s:ToggleLL()
        let g:quickfix = 'cclose'
        let g:loclist = !exists("g:loclist") || g:loclist ==# 'lclose' ? 'lopen' : 'lclose'
        silent! execute g:quickfix
        silent! execute g:loclist
    endfunction
    " ---
    augroup ale_hover
        autocmd FileType ale-preview.message setlocal nonu nornu
        autocmd FileType python,go
              \ if g:loaded_ale == 1|
              \     nnoremap <buffer> <silent>K <CMD>ALEHover<CR>|
              \ endif
    augroup END
    " ---
    set omnifunc=ale#completion#OmniFunc
    let g:ale_echo_msg_format = '[%linter% %severity%] %s'
    let g:ale_completion_enabled = 1
    let g:ale_completion_autoimport = 1
    let g:ale_lsp_suggestions = 1
    let g:ale_fix_on_save = 1
    let g:ale_virtualtext_cursor = 0
    let g:ale_linters_explicit = 1
    let g:ale_linters = {
          \      'python': ['pylsp'],
          \      'go': ['gopls', 'gofmt']
          \ }
    let g:ale_fixers = {
          \      'python': ['black'],
          \      'go': ['gofmt'],
          \      '*': ['remove_trailing_lines', 'trim_whitespace']
          \ }
    " ---
    inoremap <silent><C-c> :AleComplete<CR>
    nnoremap <silent><C-l> :ALENextWrap<CR>
    nnoremap <silent><C-h> :ALEPreviousWrap<CR>
    nnoremap <localleader>a :call <SID>ToggleLL()<CR>
    nnoremap <leader>s :ALEFindReferences<CR>
    nnoremap <leader>d :ALEGoToDefinition<CR>
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
    nnoremap <localleader>t :call <SID>Ctags()<CR>
    nnoremap <leader>a :CtrlPQuickfix<CR>
    nnoremap <leader>u :CtrlPUndo<CR>
    nnoremap <leader>i :CtrlPChange<CR>
    nnoremap <leader>f :CtrlP<space>%:p:h<CR>
    nnoremap <leader>h :CtrlPMRUFiles<CR>
    nnoremap <leader>j :CtrlPBuffer<CR>
    nnoremap <leader>k :CtrlPTag<CR>
    nnoremap <leader>l :CtrlPLine<CR>
endif
" }}}




" Copilot {{{
if &rtp =~ 'copilot'
    function! s:CopilotPanel()
        let l:panel_status = len(filter(range(1, bufnr('$')),
              \ 'bufexists(v:val) && bufname(v:val) =~# "^copilot:///"')) > 0
        let g:copilot_panel = l:panel_status ? 'close' : 'Copilot panel'
        silent! execute g:copilot_panel
    endfunction
    " ---
    let g:copilot_enabled = v:true
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
    nnoremap <localleader>b :call <SID>CopilotPanel()<CR>
endif
" }}}

" vim: fdm=marker:sw=2:sts=2:et
