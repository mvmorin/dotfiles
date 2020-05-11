"Remove vi compatibility first since it overrides a bunch of settings
set nocompatible

let mapleader=" "

" Set paths for compability with both unix and windows, before loading plugins
set rtp+=$HOME/.vim
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

	"Special formating
"	Plug 'whatyouhide/vim-lengthmatters'
"	Plug 'sheerun/vim-polyglot' "Automatic downloading of language syntax pkgs
"	Plug 'JuliaEditorSupport/julia-vim'
	Plug 'mboughaba/i3config.vim' "May need some help identifying the filetype
call plug#end()

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


"ToDo: Autoindenting/formatting, commenting/folding, short cuts, spellchecking,
"file search (ctrlp?), basic gitintegration, marks

"Basics
set fileformats=unix,dos "Set default fileformat order
set encoding=utf-8
filetype plugin indent on
syntax on
set backspace=indent,eol,start

"Setup tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

"Setup textwidth
set textwidth=80 "Insert newline after <textwidth>
set wrap "Virtual wrap to window size
set linebreak "wrap at full words
set breakindent "match wrap to indent level
set showbreak=>

"Search, highlight etc
set showmatch "Flash matching bracket
set matchtime=5
set incsearch
"set hlsearch
set ignorecase
set smartcase

"Set status, gui-options and decorations
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

"netrw setup
let g:netrw_banner = 0
let g:netrw_hide = 0
let g:netrw_liststyle = 3

"Command auto completion
set wildmode=longest,list,full

"Open new splits below or to the right
set splitbelow splitright

"No bell
set belloff=all

"Remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

"Copy to system clipboard
vnoremap <C-c> "*Y :let @+=@*<CR>
nnoremap <C-v> "*]p

"Working with buffers
set hidden

"File specific stuff
autocmd FileType tex setlocal textwidth=0 cc=0 spell spelllang=en_us
