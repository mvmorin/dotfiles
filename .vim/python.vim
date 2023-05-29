augroup python_au_cmd
	autocmd!
	autocmd BufWritePre *.py let win_save = winsaveview() | exec '%!black -q -l 100 -' | call winrestview(win_save)
augroup END
