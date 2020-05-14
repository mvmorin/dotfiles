" Remove vi compatibility first since it overrides a bunch of settings
set nocompatible

let mapleader=" "

" Set paths for compability with both unix and windows, before loading plugins
set rtp^=$HOME/.vim
set viminfo+=n$HOME/.vim/.viminfo

" Load plugins, using vim-plug, see github.com/junegunn/vim-plug. Script located
" in .vim/autoload. Commands :PlugInstall, :PlugUpdate, :PlugClean
call plug#begin('~/.vim/plugged')

	" Colorschemes to try out
	Plug 'morhetz/gruvbox'
	Plug 'arcticicestudio/nord-vim'
"	Plug 'fatih/molokai' "Does not load properly on windows
	Plug 'dracula/vim'
	Plug 'joshdick/onedark.vim'
	Plug 'KeitaNakamura/neodark.vim'
	Plug 'mhartington/oceanic-next'
	Plug 'altercation/vim-colors-solarized'
	Plug 'tomasiser/vim-code-dark'

	" Extensions
	Plug 'tpope/vim-commentary' " gc+motion to comment/uncomment
	Plug 'tpope/vim-fugitive' " :Git <command> to run git commands from vim

	" Formatting and Syntax
	Plug 'mboughaba/i3config.vim' " May need some help identifying the filetype
"	Plug 'sheerun/vim-polyglot' " Automatic downloading of language syntax pkgs
"	Plug 'JuliaEditorSupport/julia-vim'
call plug#end()

if has('Win32')
	" Don't use cmd.exe on windows, make sure some sort of bash exists in path,
	" git comes with a functional one
	set shell=bash
	set shellslash
endif

" Set colorscheme
set termguicolors
set bg=dark
"colo desert "semi-decent default
"let g:gruvbox_contrast_dark='hard' | colo gruvbox
"colo nord
"colo dracula
colo onedark
"colo neodark
"colo OceanicNext
"colo solarized
"colo codedark


" ToLearn: Autoindenting/formatting, spellchecking, file search (ctrlp?), marks,
" folding

" Basics
set fileformats=unix,dos "Set default fileformat order
set encoding=utf-8
filetype plugin indent on
syntax on
set backspace=indent,eol,start
set autoread
set scrolloff=3

" Setup tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

" Setup textwidth
set textwidth=80 "Insert newline after <textwidth>
set wrap "Virtual wrap to window size
set linebreak "wrap at full words
set breakindent "match wrap to indent level
set showbreak=>

" Search, highlight etc
set showmatch "Flash matching bracket
set matchtime=5
set incsearch
"set hlsearch
set ignorecase
set smartcase

" Set status, gui-options and decorations
set cursorline
let &colorcolumn=&textwidth
set number relativenumber
set showcmd
set laststatus=2
if has('gui_running')
	set guioptions-=m "Remove menu bar
	set guioptions-=T "Remove toolbar
	set lines=45 columns=100
	set guifont=Consolas:h11
endif
set statusline=%m\ %n)\ %f\ %y\/[%{&ff}]\ %L\ lines
set statusline+=%=
set statusline+=Line:\ %l\/%L\ Col:\ %c\/%{&textwidth}\ "

" Command auto completion
set wildmode=longest,list,full

" Basic insertmode word completion
set completeopt=longest,menuone
inoremap <expr> <S-Tab> pumvisible() ? "\<Down>" : "\<C-n>"
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
imap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

" No bell
set belloff=all

" Copy to system clipboard
vnoremap <leader>y "*Y :let @+=@*<CR>
nnoremap <leader>p "*]p

" Simple cd to file dir
command Cd cd %:p:h

" Shift lines width auto indent
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Windows
set splitbelow splitright
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

nnoremap <leader>H <C-w>H
nnoremap <leader>J <C-w>J
nnoremap <leader>K <C-w>K
nnoremap <leader>L <C-w>L

nnoremap <leader>= <C-w>=
nnoremap <leader><CR> <C-w><bar>
nnoremap <C-h> <C-w>5<
nnoremap <C-l> <C-w>5>
nnoremap <C-j> <C-w>5-
nnoremap <C-k> <C-w>5+

" Buffers
set hidden
nnoremap <leader>y :b#<CR>
nnoremap <leader>u :bn<CR>
nnoremap <leader>i :bp<CR>
command Bd b#<bar>bd#

augroup file_specific_formating
	autocmd!
	autocmd BufRead,BufNewFile *.tex, setlocal filetype=tex
	autocmd FileType latex,tex,plaintex setlocal textwidth=0 cc=0 spell spelllang=en_us
	autocmd FileType markdown setlocal spell spelllang=en_us,sv
augroup END

augroup file_pre_post_processing
	autocmd!
	"Remove trailing whitespaces
	autocmd BufWritePre * %s/\s\+$//e
augroup END

" netrw setup
nnoremap <leader>e :Explore<CR>
let g:netrw_banner=0
let g:netrw_liststyle = 3
augroup netrw_key_bindings
	autocmd!
	autocmd FileType netrw nnoremap <buffer> <leader>e :Rexplore<CR>
	autocmd FileType netrw setlocal cc=0
	autocmd FileType netrw nmap <buffer> + gn
	autocmd FileType netrw nnoremap <buffer> cd :exec 'cd' b:netrw_curdir<CR>
augroup END
