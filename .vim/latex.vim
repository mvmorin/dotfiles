let g:vimtex_view_automatic=0
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_quickfix_autoclose_after_keystrokes=10
" Disable custom warnings based on regexp
let g:vimtex_quickfix_ignore_filters = [
			\ 'I found no \(\\bibdata\|\\citation\) commands\?---while reading file \([^\S]*\).aux',
			\]
let g:vimtex_compiler_latexmk = {
			\ 'options' : [
			\   '-verbose',
			\   '-file-line-error',
			\   '-synctex=1',
			\   '-interaction=nonstopmode',
			\   '-shell-escape',
			\ ],
			\}
let g:vimtex_compiler_latexmk_engines = {'_' : '-pdf'} " Set default. Obs! Latexmk and xelatex does not work well with SumatraPDF
command LatexmkPdf
			\ let g:vimtex_compiler_latexmk_engines = {'_' : '-pdf'} <bar> norm \lx<cr>\ll
command LatexmkXe
			\ let g:vimtex_compiler_latexmk_engines = {'_' : '-xelatex'} <bar> norm \lx<cr>\ll
command LatexmkLua
			\ let g:vimtex_compiler_latexmk_engines = {'_' : '-lualatex'} <bar> norm \lx<cr>\ll

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
	let g:vimtex_view_general_options_latexmk
				\ = '-reuse-instance -forward-search @tex @line @pdf'
else
	let g:vimtex_view_method='zathura'
endif

let g:tex_stylish=1
let g:tex_flavor='latex'
let g:vimtex_indent_on_ampersands=0
augroup tex
	autocmd!
	autocmd BufRead,BufNewFile *.tex, setlocal filetype=tex
	autocmd FileType latex,tex,plaintex setlocal textwidth=0 cc=0 spell
augroup END
