function __fzy_get_directory_list -d 'Get a list of directories using fd or find'
	command find -L . \( -fstype 'dev' -o -fstype 'proc' \) -prune -o -type d -print ^/dev/null \
	| command sed 's@^\./@@'
end

function fzy_select_directory -d 'cd to a directory using fzy'
	__fzy_get_directory_list | fzy -l 15 | read -l result
	if [ -n "$result" ]
		cd $result
		# Remove last token from commandline.
		commandline -t ""
	end
	commandline -f repaint
end
