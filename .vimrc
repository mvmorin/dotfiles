" Remove vi compatibility first since it overrides a bunch of settings
set nocompatible


" Leaders and command timeouts
let mapleader=" "
set timeoutlen=500
set ttimeoutlen=100


" Set paths for compability with both unix and windows, before loading plugins
set rtp^=$HOME/.vim
set viminfo+=n$HOME/.vim/.viminfo

if has('Win32')
	" Don't use cmd.exe on windows, make sure some sort of bash exists in path,
	" git comes with a functional one
	set shell=bash
	set shellslash
endif


" Load plugins, using vim-plug, see github.com/junegunn/vim-plug. Script located
" in .vim/autoload. Commands :PlugInstall, :PlugUpdate, :PlugClean
call plug#begin('~/.vim/plugged')
	" Colorschemes to try out
	Plug 'gruvbox-community/gruvbox'

	" Extensions
	Plug 'tpope/vim-commentary' " gc+motion to comment/uncomment
	Plug 'tpope/vim-fugitive' " :Git <command> to run git commands from vim

	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " If fzf is not installed or is too out of date the first will download it locally to the plugged/fzf folder
	Plug 'junegunn/fzf.vim' " I might remove this, need better command names anyway so might as well write the whole thing myself

	" Formatting and Syntax
	Plug 'mboughaba/i3config.vim' " May need some help identifying the filetype
	Plug 'JuliaEditorSupport/julia-vim'
	Plug 'lervag/vimtex'
	Plug 'vim-python/python-syntax'
	Plug 'udalov/kotlin-vim'
call plug#end()


" Setup terminal colors
set t_8f=[38;2;%lu;%lu;%lum " set foreground color for correct truecolor in terminals
set t_8b=[48;2;%lu;%lu;%lum " set background color for correct truecolor in terminals
set termguicolors " Assume terminal support truecolor, make exceptions for those who don't
if $TERM == "rxvt-unicode-256color"
	set t_Co=256 notermguicolors
elseif $TERM == "rxvt-unicode"
	set t_Co=16 notermguicolors
endif

" Set colorscheme options
set bg=dark
let g:gruvbox_guisp_fallback='bg' " necessary to get spellcheck highlighting
colo gruvbox

" Read colorscheme from xresources if possible
let xrdb_colorscheme = system(
			\ "xrdb -query | sed -n -e 's/\\(^vim.colorscheme\\):\t\\(.*\\)/\\2/p'" )
if xrdb_colorscheme != ""
	exec 'colo 'xrdb_colorscheme
endif

" Basics
set fileformats=unix,dos "Set default fileformat order
set encoding=utf-8
filetype plugin indent on
syntax on
set backspace=indent,eol,start
set autoread
set scrolloff=2
set belloff=all
set nostartofline
set spelllang=en_us,sv
set noswapfile
set foldopen-=search " don't open folds when going through search results

" augroup remove_trailing_whitespaces
" 	autocmd!
" 	autocmd BufWritePre * %s/\s\+$//e
" augroup END

" Setup default tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab


" Setup textwidth
set textwidth=120
set formatoptions-=t "don't indent text/code
set wrap "virtual wrap to window size
set linebreak "virtual wrap at full words
set breakindent "match virtual wrap to indent level
set showbreak=>


" Search, highlight etc
set showmatch "Flash matching bracket
set matchtime=5
set incsearch
set nohlsearch
set ignorecase
set smartcase


" Command/file auto completion
set path+=**
set wildmode=longest,list,full


" Use expanded % matching
runtime! macros/matchit.vim


" Set status, gui-options and decorations
set cursorline
let &colorcolumn=&textwidth
set number relativenumber
set showcmd
set laststatus=2
set guioptions= " Remove all gui items
if has('gui_running') && has('Win32')
	set lines=45 columns=100 guifont=Consolas:h11
endif

augroup ActiveWindowModifiers " turn of cursorline on inactive windows
autocmd!
autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline
augroup END

set statusline=
set statusline+=%m\ %n)\ %f\ %y\ [%{&ff}]\ [%{&encoding}]
set statusline+=\ %{&spell?'[':''}%{&spell?&spelllang:''}%{&spell?']':''}
set statusline+=%=
set statusline+=Line:\ %l\/%L\ Col:\ %c\/%{strwidth(getline('.'))}\ "

" modify default gruvbox statusline colors slightly
" slightly sharper contrast between active and inactive windows, active: bg2->bg3, inactive: bg1->bg0_s and fg4->bg4
hi StatusLine   ctermbg=241  guibg=#665c54 ctermfg=223 guifg=#ebdbb2 cterm=none gui=none
hi StatusLineNC ctermbg=236 guibg=#32302f ctermfg=243 guifg=#7c6f64 cterm=none gui=none
" make quickfix line slightly less bright yellow and invert bg and fg
hi QuickFixLine ctermbg=235 guibg=#282828 ctermfg=172 guifg=#d79921 cterm=bold gui=bold


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remaps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Spelling toggle
nnoremap <leader>s :set spell!<CR>

" Basic insertmode word completion
set completeopt=longest,menuone
inoremap <Tab>i <C-x><C-n>
" inoremap <Tab>i <C-x><C-i>
inoremap <Tab>o <C-x><C-o>
inoremap <Tab>f <C-x><C-f>
inoremap <Tab>s <C-x>s
inoremap <C-Tab> <Tab>

" popup menu navigation
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
imap <expr> j pumvisible() ? "\<C-n>" : "j"
imap <expr> k pumvisible() ? "\<C-p>" : "k"

" Copy to system clipboard
vnoremap <leader>y "*y :let @+=@*<CR>
nnoremap <leader>p "*]p

" Window movement
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

nnoremap <leader>H <C-w>H
nnoremap <leader>J <C-w>J
nnoremap <leader>K <C-w>K
nnoremap <leader>L <C-w>L

nnoremap <Esc>, <C-w>><C-W>>
nnoremap <Esc>m <C-w><<C-w><
nnoremap <Esc>; <C-w>+<C-w>+
nnoremap <Esc>M <C-w>-<C-w>-
nnoremap <Esc><CR> <C-w>=

nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>o <C-w>o

" Buffers
set hidden
nnoremap <leader>y :b#<CR>
nnoremap <leader>u :bn<CR>
nnoremap <leader>i :bp<CR>
command Bd b#<bar>bd#
" nnoremap <leader>y :silent! argument<CR>:args<CR>
" nnoremap <leader>u :silent! prev<CR>:args<CR>
" nnoremap <leader>i :silent! next<CR>:args<CR>
" nnoremap <leader>a :$argedit %<CR>:args<CR>
" nnoremap <leader>d :argdelete %<CR>:args<CR>

" fuzzy finding, (fzf plugin)
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :BLines<CR>

" Vimgrep for word under coursor
nnoremap <C-p><C-f> :lvimgrep /\<<C-r><C-w>\>/j %<CR>
nnoremap <C-p><C-p> :lvimgrep /\<<C-r><C-w>\>/j **/*

" quickfix movement
" nnoremap [q :cprev<CR>
" nnoremap ]q :cnext<CR>
nnoremap <esc>Q :cprev<CR>
nnoremap <esc>q :cnext<CR>
nnoremap <leader>q :copen15<CR>
nnoremap <leader>Q :cclose<CR>
" this toggle functions doesnt work well with multiple loc-lists open
" nnoremap <expr> <leader>q empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'

" loc-list movement
" nnoremap [w :lprev<CR>
" nnoremap ]w :lnext<CR>
nnoremap <esc>W :lprev<CR>
nnoremap <esc>w :lnext<CR>
nnoremap <leader>w :lopen15<CR>
nnoremap <leader>W :lclose<CR>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype settings, no real remaps should be done in these, simply style and plugin settings
" Maybe I should just do it correctly and put this stuff in proper ftplugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime markdown.vim
runtime latex.vim
runtime julia.vim
runtime i3config.vim
runtime python.vim
runtime cython.vim
runtime dockerfile.vim
