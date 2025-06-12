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
    " Colorschemes
    Plug 'gruvbox-community/gruvbox'
    Plug 'christoomey/vim-tmux-navigator'

    " Extensions
    Plug 'tpope/vim-commentary' " gc+motion to comment/uncomment
    Plug 'tpope/vim-fugitive' " :Git <command> to run git commands from vim

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " If fzf is not installed or is too out of date the first will download it locally to the plugged/fzf folder
    Plug 'junegunn/fzf.vim'
    Plug 'dense-analysis/ale'

    " Formatting and Syntax
    Plug 'mboughaba/i3config.vim' " May need some help identifying the filetype
    Plug 'JuliaEditorSupport/julia-vim'
    Plug 'lervag/vimtex'
    Plug 'vim-python/python-syntax'
    Plug 'udalov/kotlin-vim'

    " bug fix for getting FocusGained/FocusLost events to work, needed for correct autoread functionallity
    " see: https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    Plug 'tmux-plugins/vim-tmux-focus-events'
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

" Triger `autoread` when files changes on disk
" see: https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
" Notification after file change
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None


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
" ALE Config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" wanted behavoir:
" per language and per project linter setups, everything disabled by default
" run fixer on save
" build/make to location/quickfix list (not really ale but related)
"

let g:ale_linters_ignore={'cython': ['cython'], 'pyrex': ['cython'], 'python': ['flake8','ruff','mypy','pyright','pylint']}

let g:ale_set_loclist=0
let g:ale_set_quickfix=0
let g:ale_sign_column_always=1 " don't flicker the sign column on and off
let g:ale_keep_list_window_open=1

let g:ale_hover_cursor=0
let g:ale_set_balloons=0
let g:ale_hover_to_preview=1 " always give hover info in preview window
set previewheight=7

let g:ale_completion_enabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remaps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" helper functions to create mappings that toggle between two commands
function! ToggleMap(name, bind, first, second)
    execute 'let g:toggle_map_' . a:name . '="' . a:bind .'"'
    execute 'nnoremap <silent>' a:bind ':call ToggleMapFirst("g:toggle_map_' . a:name . '", "' . a:first . '", "' . a:second . '")<CR>'
endfunction

function! ToggleMapFirst(global_var, first, second) abort
    execute a:first
    execute 'let l:local_var=' . a:global_var
    execute 'nnoremap <silent>' l:local_var ' :call ToggleMapSecond("' . a:global_var . '", "' . a:first . '", "' . a:second . '")<CR>'
endfunction

function! ToggleMapSecond(global_var, first, second) abort
    execute a:second
    execute 'let l:local_var=' . a:global_var
    execute 'nnoremap <silent>' l:local_var ' :call ToggleMapFirst("' . a:global_var . '", "' . a:first . '", "' . a:second . '")<CR>'
endfunction

" Copy to system clipboard
vnoremap <leader>y "*y :let @+=@*<CR>
nnoremap <leader>p "*]p

" Window mevement that allow for movement outside to tmux
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <Esc>h :<C-U>TmuxNavigateLeft<CR>
nnoremap <silent> <Esc>j :<C-U>TmuxNavigateDown<CR>
nnoremap <silent> <Esc>k :<C-U>TmuxNavigateUp<CR>
nnoremap <silent> <Esc>l :<C-U>TmuxNavigateRight<CR>

nnoremap <leader><Esc>h <C-w>H
nnoremap <leader><Esc>j <C-w>J
nnoremap <leader><Esc>k <C-w>K
nnoremap <leader><Esc>l <C-w>L

nnoremap <Esc>, <C-w>><C-W>>
nnoremap <Esc>m <C-w><<C-w><
nnoremap <Esc>; <C-w>+<C-w>+
nnoremap <Esc>M <C-w>-<C-w>-
nnoremap <Esc><CR> <C-w>=

nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>c <C-w>c
nnoremap <leader>o <C-w>o

" quickfix movement
nnoremap <esc>Q :cprev<CR>
nnoremap <esc>q :cnext<CR>
call ToggleMap("quickfix_list_open_close", "<leader>q", "copen15", "cclose")

" loc-list movement
nnoremap <esc>W :lprev<CR>
nnoremap <esc>w :lnext<CR>
call ToggleMap("loc_list_open_close", "<leader>w", "lopen15", "lclose")

" ale
call ToggleMap("ale_hover_open_close", "<leader>fh", "ALEHover", "pclose")
nnoremap <leader>fd :ALEGoToDefinition<CR>
nnoremap <leader>fs :ALEGoToTypeDefinition<CR>
nnoremap <leader>fe :ALEPopulateQuickfix<CR>
nnoremap <leader>fr :ALEFindReferences -quickfix<CR>

" fuzzy finding, (fzf plugin)
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :BLines<CR>

" Vimgrep for word under coursor
nnoremap <leader>fg :lvimgrep /\<<C-r><C-w>\>/j %<CR>
nnoremap <leader>fp :lvimgrep /\<<C-r><C-w>\>/j **/*

" Basic insertmode word completion
set completeopt=longest,menuone
inoremap <C-n> <C-x><C-n>
inoremap <C-n><C-n> <C-x><C-n>
inoremap <C-n><C-o> <C-x><C-o>
inoremap <C-n><C-f> <C-x><C-f>
inoremap <C-n><C-p> <C-x>s

" popup menu navigation
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
imap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"


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
