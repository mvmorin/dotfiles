" Remove vi compatibility first since it overrides a bunch of settings
set nocompatible


" Leaders and command timeouts
let mapleader=" "
set timeoutlen=500
set ttimeoutlen=1000


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
	Plug 'morhetz/gruvbox'
	Plug 'arcticicestudio/nord-vim'
	Plug 'joshdick/onedark.vim'
	Plug 'mhartington/oceanic-next'
	Plug 'altercation/vim-colors-solarized'
	Plug 'drewtempelmeyer/palenight.vim'
	Plug 'jacoborus/tender.vim'

	" Simple mode
	Plug 'junegunn/goyo.vim'

	" Extensions
	Plug 'tpope/vim-commentary' " gc+motion to comment/uncomment
	Plug 'tpope/vim-fugitive' " :Git <command> to run git commands from vim
	Plug 'jpalardy/vim-slime' " For sending text to terminal manager (screen,tmux...)

	" Formatting and Syntax
"	Plug 'sheerun/vim-polyglot' " Automatic downloading of language syntax pkgs
	Plug 'mboughaba/i3config.vim' " May need some help identifying the filetype
	Plug 'JuliaEditorSupport/julia-vim'
	Plug 'lervag/vimtex'
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


" Set colorscheme
set bg=dark
let g:gruvbox_guisp_fallback='bg'
colo gruvbox
" colo nord
" colo onedark
" colo OceanicNext
" colo solarized
" Read from xresources if possible
let xrdb_colorscheme = system(
			\ "xrdb -query | sed -n -e 's/\\(^vim.colorscheme\\):\t\\(.*\\)/\\2/p'" )
if xrdb_colorscheme != ""
	exec 'colo 'xrdb_colorscheme
endif


" ToLearn: Autoindenting/formatting, file search (ctrlp?), marks, folding


" Basics
set fileformats=unix,dos "Set default fileformat order
set encoding=utf-8
filetype plugin indent on
syntax on
set backspace=indent,eol,start
set autoread
set scrolloff=3
set belloff=all


" Setup tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab


" Setup textwidth
set textwidth=80
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

command Focus call ToggleSingleLineFocus()
function ToggleSingleLineFocus()
	if !exists("w:single_line_focus_on")
		let w:single_line_focus_on = 0
	endif

	if w:single_line_focus_on
		let w:single_line_focus_on = 0
		let &conceallevel = w:old_conceallevel
		2match
		Goyo!
	else
		Goyo 80%x3
		let w:single_line_focus_on = 1
		let w:old_conceallevel = &conceallevel
		let &conceallevel = 3
		2match Conceal /^.*$/
		norm z.
		echo ""
	endif
endfunction


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
set statusline=%m\ %n)\ %f\ %y\ [%{&ff}]\ [%{&encoding}]
set statusline+=\ %{&spell?'[':''}%{&spell?&spelllang:''}%{&spell?']':''}
set statusline+=%=
set statusline+=Line:\ %l\/%L\ Col:\ %c\/%{strwidth(getline('.'))}\ "


" Command/file auto completion
set path+=**
set wildmode=longest,list,full


" Spelling
set spelllang=en_us,sv
nnoremap <leader>s :set spell!<CR>


" Basic insertmode word completion
set completeopt=longest,menuone
inoremap <Tab>i <C-x><C-i>
inoremap <Tab>o <C-x><C-o>
inoremap <Tab>f <C-x><C-f>
inoremap <Tab>s <C-x>s
inoremap <Tab><Tab> <C-e>
inoremap <C-Tab> <Tab>
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
imap <expr> j pumvisible() ? "\<C-n>" : "j"
imap <expr> k pumvisible() ? "\<C-p>" : "k"


" Copy to system clipboard
vnoremap <leader>y "*y :let @+=@*<CR>
nnoremap <leader>p "*]p


" Simple cd to file dir
command Cd cd %:p:h


" Better half page movments
nnoremap <C-u> M<C-u>
nnoremap <C-d> M<C-d>


" Window movement
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

nnoremap <leader>H <C-w>H
nnoremap <leader>J <C-w>J
nnoremap <leader>K <C-w>K
nnoremap <leader>L <C-w>L

nnoremap <leader>= <C-w>=
nnoremap <leader><CR> <C-w><bar><C-w>_


" Buffers
set hidden
nnoremap <leader>y :b#<CR>
nnoremap <leader>u :bn<CR>
nnoremap <leader>i :bp<CR>
command Bd b#<bar>bd#


" Vim-Slime
let g:slime_no_mappings=1
let g:slime_target="tmux"
nmap <C-c>v <Plug>SlimeConfig
nmap <C-c><C-p> <Plug>SlimeParagraphSend
nnoremap <C-c><C-c> :SlimeSend<CR>
xmap <C-c><C-c> <Plug>SlimeRegionSend


" Pre/post processing
augroup file_pre_post_processing
	autocmd!
	"Remove trailing whitespaces
	autocmd BufWritePre * %s/\s\+$//e
augroup END


" netrw setup
function LaunchExplore()
	if expand("#") == ""
		Explore
	else
		let olddir=expand("%:h")
		b#
		exec 'Explore 'olddir
	endif
endfunction
nnoremap <leader>e :call LaunchExplore()<cr>
let g:netrw_banner=0
let g:netrw_liststyle = 1 " Would prefer style 3 but it has problems
augroup netrw_key_bindings
	autocmd!
	autocmd FileType netrw nnoremap <buffer> <leader>e :b#<cr>
	autocmd FileType netrw setlocal cc=0
	autocmd FileType netrw nnoremap <buffer> cd :exec 'cd' b:netrw_curdir<CR>
augroup END


" Tex and markdown
let g:vimtex_compiler_enabled=0
let g:vimtex_view_automatic=0
" These mappings conflicts/slows down the oridnary t{char} map
let g:vimtex_mappings_disable = {
			\ 'n': ['tsf', 'tsc', 'tse', 'tsd', 'tsD'],
			\ 'x': ['tsf', 'tsd', 'tsD'],
			\}
if has('Win32') || has('Win32Unix')
	let g:vimtex_view_method='general'
	let g:vimtex_view_general_viewer = 'SumatraPDF'
	let g:vimtex_view_general_options
		\ = '-reuse-instance -forward-search @tex @line @pdf'
else
	let g:vimtex_view_method='zathura'
endif
let g:tex_stylish=1
let g:vimtex_indent_on_ampersands=0
augroup tex_and_markdown
	autocmd!
	autocmd BufRead,BufNewFile *.tex, setlocal filetype=tex
	autocmd FileType latex,tex,plaintex setlocal textwidth=0 cc=0 spell
	autocmd FileType markdown setlocal spell formatoptions+=t

	" For now just map these simple compile commands, we'll see if I ever feel
	" latexmk or similar is worth the dependency
	autocmd FileType tex nnoremap <localleader>ll
				\ :w <bar> exec "silent !texbuild %" <bar> redraw! <bar> VimtexView <cr>
	autocmd FileType tex nnoremap <localleader>llb
				\ :w <bar> exec "silent !texbuild % -b" <bar> redraw! <bar> VimtexView <cr>
	autocmd FileType tex nnoremap <localleader>llx
				\ :w <bar> exec "silent !texbuild % -x" <bar> redraw! <bar> VimtexView <cr>
	autocmd FileType tex nnoremap <localleader>llxb
				\ :w <bar> exec "silent !texbuild % -xb" <bar> redraw! <bar> VimtexView <cr>
augroup END


" Julia
augroup julia_code
	autocmd!
	autocmd FileType julia setlocal commentstring=#\ %s
	autocmd FileType julia let b:slime_config = {"socket_name": "default", "target_pane": "Jmux:0"}
augroup END


" i3 config
augroup i3_config_file
	autocmd!
	autocmd BufNewFile,BufRead *i3/config set filetype=i3config
augroup END
