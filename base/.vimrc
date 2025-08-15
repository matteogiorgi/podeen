" ~/.vimrc: simple Vim9 configuration file,
" no plugin, just settings and keymaps
" ---
" Vim editor - https://www.vim.org




" Vim9 {{{
if v:version < 900
    finish
elseif !isdirectory(expand('~/.vim'))
    silent! execute "!mkdir -p ~/.vim &>/dev/null"
endif
" }}}




" GVim {{{
if has('gui_running')
    set vb t_vb=
    set columns=120 lines=50
    set guioptions=i
    set guicursor+=a:blinkon0
    set guifont=Monospace\ 10
    " ---
    if system('fc-list') =~ 'Cascadia Code'
        set guifont=Cascadia\ Code\ 10
    endif
    " ---
    if has('unnamedplus')
        set clipboard=unnamedplus
    endif
endif
" }}}




" Undodir {{{
if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        silent! execute "!mkdir -p ~/.vim/undodir &>/dev/null"
    endif
    set undodir=${HOME}/.vim/undodir
    set undofile
endif
" }}}




" Leaders, Caret & Linebreak {{{
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" ---
if has('linebreak')
    let &showbreak='  ~'
endif
" }}}




" Syntax & Filetype {{{
syntax on
filetype plugin indent on
set background=light
silent! colorscheme lunaperche
" }}}




" Options {{{
set exrc
set title
set shell=bash
set runtimepath+=~/.vim_runtime
set number relativenumber mouse=a ttymouse=sgr
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set foldenable foldcolumn=0 foldmethod=indent foldlevelstart=99 foldnestmax=10 foldminlines=1
set textwidth=120 wrapmargin=0
set formatoptions=tcroqaj
set ruler scrolloff=8 sidescrolloff=16
set autoindent autoread
set formatoptions+=l
set hlsearch incsearch
set nowrap nospell conceallevel=0
set ignorecase smartcase smartindent
set noswapfile nobackup
set showmode showcmd
set noerrorbells novisualbell
set cursorline cursorlineopt=number,line
set splitbelow splitright
set equalalways
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=100
set timeoutlen=2000
set ttimeoutlen=0
set termencoding=utf-8 encoding=utf-8 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set viminfo='100,<50,s10,h
set cmdheight=1
set nrformats-=alpha
set fillchars=vert:┃,eob:╺
set laststatus=2 showtabline=1
set termguicolors
set nocompatible
set esckeys
" ---
set path+=**
set completeopt=menuone,popup,noinsert,noselect
set complete=.,w,b,u,t,i,kspell
set complete+=k/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english
set wildmenu wildoptions=fuzzy,pum,tagfile
set wildchar=<Tab> wildmode=full
set wildignore=*/.git/*,*/.hg/*,*/.svn/*,*/tmp/*,*.so,*.swp,*.zip
set shortmess+=c
set belloff+=ctrlg
" }}}




" Functions {{{
function! s:CTags()
    if executable('ctags')
        silent! execute '!ctags -R --exclude=.git 2>/dev/null'
        redraw!|redrawstatus!|redrawtabline
        echo 'ctags executed'
        return
    endif
    echo 'ctags not found'
endfunction
" ---
function! s:CopyClip()
    if executable('xclip')
        let @" = system('xclip -selection clipboard &>/dev/null', getreg(''))
        echo 'xclip copy'
        return
    endif
    echo 'xclip not found'
endfunction
" ---
function! s:CleanUpdate()
    let l:pos = getpos(".")
    silent! %s/\s\+$//e
    silent! %s/\n\+\%$//e
    call setpos('.', l:pos)
    silent! update
    echo 'clean update'
endfunction
" ---
function! s:ToggleQF()
    silent! lclose
    if empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&filetype") ==# "qf"'))
        silent! copen
        return
    endif
    silent! cclose
endfunction
" ---
function! s:ToggleFC()
    let &foldcolumn = (&foldcolumn + 1) % 2
endfunction
" ---
function! s:ToggleWM()
    if exists('b:wrapmotion') && b:wrapmotion
        unlet b:wrapmotion
        setlocal nowrap
        silent! nunmap <buffer> j
        silent! xunmap <buffer> j
        silent! ounmap <buffer> j
        silent! nunmap <buffer> k
        silent! xunmap <buffer> k
        silent! ounmap <buffer> k
        silent! nunmap <buffer> 0
        silent! xunmap <buffer> 0
        silent! ounmap <buffer> 0
        silent! nunmap <buffer> $
        silent! xunmap <buffer> $
        silent! ounmap <buffer> $
        echo "wrapmotion off"
    else
        let b:wrapmotion = 1
        setlocal wrap
        nnoremap <buffer> <expr> j (v:count == 0 ? 'gj' : 'j')
        xnoremap <buffer> <expr> j (v:count == 0 ? 'gj' : 'j')
        onoremap <buffer> <expr> j (v:count == 0 ? 'gj' : 'j')
        nnoremap <buffer> <expr> k (v:count == 0 ? 'gk' : 'k')
        xnoremap <buffer> <expr> k (v:count == 0 ? 'gk' : 'k')
        onoremap <buffer> <expr> k (v:count == 0 ? 'gk' : 'k')
        nnoremap <buffer> 0 g0
        xnoremap <buffer> 0 g0
        onoremap <buffer> 0 g0
        nnoremap <buffer> $ g$
        xnoremap <buffer> $ g$
        onoremap <buffer> $ g$
        echo "wrapmotion on"
    endif
endfunction
" ---
function! s:AddLineQF()
    let l:qf_list = getqflist()
    let l:qf_entry = {
              \ 'bufnr': bufnr("%"),
              \ 'lnum': line("."),
              \ 'col': col("."),
              \ 'text': getline("."),
              \ 'filename': expand("%:p"),
          \ }
    call add(l:qf_list, l:qf_entry)
    call setqflist(l:qf_list)
    echo 'quickfix newline'
endfunction
" ---
function! s:ResetQF()
    call setqflist([])
    echo 'quickfix resetted'
endfunction
" ---
function! s:ResetSR()
    let @/=""
    echo 'search resetted'
endfunction
" ---
function! s:ScratchBuffer()
    if &filetype ==# 'scratch'
        b#|return
    endif
    let target_buffer = bufnr('/tmp/scratchbuffer')
    let target_window = bufwinnr(target_buffer)
    if target_buffer != -1 && target_window != -1
        silent! execute target_window . 'wincmd w'
    else
        edit /tmp/scratchbuffer
        setlocal bufhidden=hide
        setlocal nobuflisted
        setlocal noswapfile
        setlocal filetype=scratch
        setlocal nospell
    endif
endfunction
" ---
function! s:GuiFont()
    if has('gui_running')
        silent! execute 'set guifont=*'
    else
        echo 'not in gvim'
    endif
endfunction
" }}}




" Augroups {{{
augroup netrw_prettyfier
    autocmd!
    autocmd FileType netrw
          \ cd %:p:h|
          \ setlocal nonu nornu|
          \ setlocal bufhidden=delete|
          \ setlocal nobuflisted|
          \ setlocal cursorline
    autocmd VimEnter *
          \ if !argc() && exists(':Explore')|
          \     Explore|
          \ endif
    let g:netrw_keepdir = 0
    let g:netrw_banner = 0
    let g:netrw_liststyle = 4
    let g:netrw_sort_options = 'i'
    let g:netrw_sort_sequence = '[\/]$,*'
    let g:netrw_browsex_viewer = 'xdg-open'
    let g:netrw_list_hide = '^\./$'
    let g:netrw_hide = 1
    let g:netrw_preview = 0
    let g:netrw_alto = 1
    let g:netrw_altv = 0
augroup end
" ---
augroup syntax_complete
    autocmd!
    autocmd FileType * set omnifunc=syntaxcomplete#Complete
augroup end
" ---
augroup syntax_prettyfier
    autocmd!
    autocmd VimEnter,ColorScheme *
          \ hi! LineNr ctermbg=NONE guibg=NONE|
          \ hi! Folded ctermbg=NONE guibg=NONE|
          \ hi! FoldColumn ctermbg=NONE guibg=NONE|
          \ hi! SignColumn ctermbg=NONE guibg=NONE|
          \ hi! CursorLine cterm=NONE gui=NONE|
          \ hi! CursorLineNr cterm=bold ctermbg=NONE gui=bold guibg=NONE|
          \ hi! MatchParen cterm=underline ctermbg=NONE gui=underline guibg=NONE|
          \ hi! VertSplit cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
augroup end
" ---
augroup fold_autoload
    autocmd!
    autocmd BufWinEnter *
          \ if expand('%:t') != ''|
          \     silent! loadview|
          \ endif
    autocmd BufWinLeave *
          \ if expand('%:t') != ''|
          \     silent! mkview|
          \ endif
augroup end
" ---
augroup linenumber_prettyfier
    autocmd!
    autocmd InsertEnter *
          \ if index(['tex', 'markdown', 'html', 'text', 'scratch'], &filetype) == -1|
          \     let &colorcolumn = '121,'.join(range(121,999),',')|
          \ endif|
          \ setlocal nocursorline|
          \ setlocal number norelativenumber
    autocmd InsertLeave,BufWinEnter *
          \ setlocal colorcolumn=|
          \ setlocal cursorline|
          \ setlocal number relativenumber
augroup end
" ---
augroup writer_filetype
    autocmd!
    autocmd FileType plaintex setfiletype=tex
    autocmd FileType tex,markdown,html,text,scratch
          \ setlocal formatoptions=|
          \ setlocal spell conceallevel=0|
          \ setlocal spelllang=en_us|
          \ setlocal foldmethod=manual|
          \ silent! call <SID>ToggleWM()
augroup end
" ---
augroup scratchbuffer_autosave
    autocmd!
    autocmd TextChanged,TextChangedI,BufLeave /tmp/scratchbuffer
          \ if &modified && &modifiable|
          \     silent write|
          \ endif
augroup end
" ---
augroup ctags_onsave
    autocmd!
    autocmd BufWritePost *
          \ if filereadable('tags')|
          \     silent! call <SID>CTags()|
          \ endif
augroup end
" ---
augroup viminfo_sync
    autocmd!
    autocmd TextYankPost * silent! wviminfo
augroup end
" }}}




" Commands {{{
command! -nargs=0 CTags call <SID>CTags()
command! -nargs=0 CopyClip call <SID>CopyClip()
command! -nargs=0 CleanUpdate call <SID>CleanUpdate()
command! -nargs=0 ToggleQF call <SID>ToggleQF()
command! -nargs=0 ToggleFC call <SID>ToggleFC()
command! -nargs=0 ToggleWM call <SID>ToggleWM()
command! -nargs=0 AddLineQF call <SID>AddLineQF()
command! -nargs=0 ResetQF call <SID>ResetQF()
command! -nargs=0 ResetSR call <SID>ResetSR()
command! -nargs=0 ScratchBuffer call <SID>ScratchBuffer()
command! -nargs=0 GuiFont call <SID>GuiFont()
" }}}




" Keymaps {{{
nnoremap <silent><C-n> :bnext<CR>
nnoremap <silent><C-p> :bprev<CR>
nnoremap <silent><Tab> :buffer#<CR>
" ---
noremap <silent><C-h> (
noremap <silent><C-l> )
noremap <silent><C-j> }
noremap <silent><C-k> {
" ---
vnoremap <silent>H <gv
vnoremap <silent>L >gv
xnoremap <silent>J :move '>+1<CR>gv=gv
xnoremap <silent>K :move '<-2<CR>gv=gv
" ---
nnoremap <silent>Y y$
nnoremap <silent>ZU :update<BAR>rviminfo<CR>
" ---
nnoremap <leader>q :ToggleQF<CR>
nnoremap <leader>w :ToggleWM<CR>
nnoremap <leader>e :ResetSR<CR>
nnoremap <leader>r :ResetQF<CR>
nnoremap <leader>t :CTags<CR>
nnoremap <leader>a :AddLineQF<CR>
nnoremap <leader>s :ScratchBuffer<CR>
nnoremap <leader>d :CleanUpdate<CR>
nnoremap <leader>g :GuiFont<CR>
nnoremap <leader>z :ToggleFC<CR>
nnoremap <leader>c :CopyClip<CR>
" }}}

" vim: fdm=marker:sw=2:sts=2:et
