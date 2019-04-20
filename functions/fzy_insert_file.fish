function __fzy_get_file_list
	command find -L . \( -fstype 'dev' -o -fstype 'proc' \) -prune -o -type f -print ^/dev/null \
	| command sed 's@^\./@@'
end

function fzy_insert_file
	__fzy_get_file_list | fzy -l 15 | read -l result
	if [ -z "$result" ]
		commandline -f repaint
		return
	else
		# Remove last token from commandline.
		commandline -t ""
	end
	for i in $result
		commandline -it -- (string escape $i)
		commandline -it -- ' '
	end
	commandline -f repaint
end
