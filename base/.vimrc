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
colorscheme lunaperche
set background=light
" }}}




" Options {{{
set exrc
set title
set shell=bash
set runtimepath+=~/.vim_runtime
set number relativenumber mouse=a ttymouse=sgr
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set foldenable foldcolumn=1 foldmethod=indent foldlevelstart=99 foldnestmax=10 foldminlines=1
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
set colorcolumn=0
set cmdheight=1
set nrformats-=alpha
set fillchars=vert:┃,eob:╺
set laststatus=2 showtabline=1
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
function! s:ScratchBuffer()
    let target_buffer = bufnr('/tmp/scratchbuffer')
    let target_window = bufwinnr(target_buffer)
    if target_buffer != -1 && target_window != -1
        silent! execute target_window . 'wincmd w'
    else
        edit /tmp/scratchbuffer
        setlocal bufhidden=wipe
        setlocal nobuflisted
        setlocal noswapfile
        setlocal filetype=scratch
        setlocal nospell
    endif
endfunction
" ---
function! s:ToggleScratch()
    let l:scratch_wins = filter(range(1, winnr('$')), 'getwinvar(v:val, "&filetype") == "scratch"')
    if !empty(l:scratch_wins)
        let l:cur_win = winnr()
        silent! execute l:scratch_wins[0] . 'wincmd w'|buffer #
        silent! execute l:cur_win . "wincmd w"
    elseif exists(':ScratchBuffer')
            silent! ScratchBuffer
    endif
endfunction
" ---
function! s:ToggleEx()
    let l:netrw_wins = filter(range(1, winnr('$')), 'getwinvar(v:val, "&filetype") == "netrw"')
    if !empty(l:netrw_wins)
        let l:cur_win = winnr()
        silent! execute l:netrw_wins[0] . 'wincmd w'|buffer #
        silent! execute l:cur_win . "wincmd w"
    else
        edit .
    endif
endfunction
" ---
function! s:ToggleQF()
    silent! lclose
    if empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&filetype") ==# "qf"'))
        silent! copen
    else
        silent! cclose
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
    echo 'line 2quickfix'
endfunction
" ---
function! s:ResetQF()
    call setqflist([])
    echo 'reset quickfix'
endfunction
" ---
function! s:CTags()
    silent! execute '!ctags -R --exclude=.git'
    redraw!|redrawstatus!|redrawtabline
    echo 'ctags executed'
endfunction
" ---
function! s:ClearSpaces()
    let l:pos = getpos(".")
    %s/\s\+$//e
    %s/\n\+\%$//e
    call setpos('.', l:pos)
    echo 'cleared spaces'
endfunction
" ---
function! s:ClearSearch()
    let @/=""
    echo 'cleared search'
endfunction
" ---
function! s:CopyClip()
    let @" = system('xclip -selection clipboard', getreg(''))
    echo 'copied 2clipboard'
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
          \ hi! MatchParen cterm=underline ctermbg=NONE|
          \ hi! VertSplit ctermbg=NONE
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
          \ setlocal nocursorline|
          \ setlocal number norelativenumber
    autocmd InsertLeave *
          \ setlocal cursorline|
          \ setlocal number relativenumber
augroup end
" ---
augroup writer_filetype
    autocmd!
    autocmd FileType plaintex setfiletype=tex
    autocmd FileType tex,markdown,html,text,scratch
          \ setlocal formatoptions=|
          \ setlocal wrap spell conceallevel=0|
          \ setlocal spelllang=en_us|
          \ setlocal foldmethod=manual
augroup end
" ---
augroup scratchbuffer_autosave
    autocmd!
    autocmd TextChanged,TextChangedI /tmp/scratchbuffer silent write
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
command! -nargs=0 ScratchBuffer call <SID>ScratchBuffer()
command! -nargs=0 ToggleScratch call <SID>ToggleScratch()
command! -nargs=0 ToggleEx call <SID>ToggleEx()
command! -nargs=0 ToggleQF call <SID>ToggleQF()
command! -nargs=0 AddLineQF call <SID>AddLineQF()
command! -nargs=0 ResetQF call <SID>ResetQF()
command! -nargs=0 CTags call <SID>CTags()
command! -nargs=0 ClearSpaces call <SID>ClearSpaces()
command! -nargs=0 ClearSearch call <SID>ClearSearch()
command! -nargs=0 CopyClip call <SID>CopyClip()
" }}}




" Keymaps {{{
noremap <buffer> j gj
noremap <buffer> k gk
noremap <buffer> 0 g0
noremap <buffer> $ g$
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
nnoremap <leader>e :ToggleEx<CR>
nnoremap <leader>q :ToggleQF<CR>
nnoremap <leader>a :AddLineQF<CR>
nnoremap <leader>r :ResetQF<CR>
nnoremap <leader>t :CTags<CR>
nnoremap <leader>s :ToggleScratch<CR>
nnoremap <leader>d :ClearSpaces<CR>
" }}}

" vim: fdm=marker:sw=2:sts=2:et
