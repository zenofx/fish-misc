bind \cr 'fzy_select_history (commandline -b)'
bind \cf 'fzy_insert_file'
bind \cg 'fzy_select_directory'

function misc_uninstall -e misc_uninstall
	bind -e \cr
	bind -e \cf
	bind -e \cg
end
