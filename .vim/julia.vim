augroup julia_code
	autocmd!

	hi link Operator Delimiter
	hi link juliaParDelim Statement
	hi link juliaSemicolon Statment
	hi link juliaComma Statement
	hi link juliaFunctionCall Identifier

	autocmd FileType julia setlocal commentstring=#\ %s
augroup END
