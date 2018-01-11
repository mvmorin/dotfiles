" Specify the behaviour of the editor: text wrapping, tabbing, ,autocomplete
" etc


" Setup line length handling and restrictions
function! SetOwnLineLength(width)
	let &textwidth=a:width
	exec "LengthmattersReload"
endfunction
command! -nargs=1 SetLineLen call SetOwnLineLength(<f-args>)
command! LengthMatters LengthmattersToggle

set textwidth=80		" Default line lengths

set wrap				" Wrap text to fit on screen
set linebreak			" Only wrap complete words
set showbreak=-->		" Set indicator for wrapped line



" Setup tabbing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set autoindent

"set smartindent		"General smart identation, interfers widht file specific
"set smarttab

filetype plugin indent on



" Autocompletion and syntax highlighting
set showmatch			" Flash the matching bracket
set matchtime=5			" Flash matching bracket for half a second
"SuperTab or YouCompleteMe?



" Block Folding



" Text And File Search
set hlsearch
set incsearch

set smartcase
set ignorecase



" General editor setup
set undolevels=1000



" Interaction with peripherals

set backspace=indent,eol,start "Make backspace behave like normal
set mouse="" "No mouse

