function __fish_version_gt -a expected actual -d "Compare versions."
	if [ -z "$actual" ]
		set actual $FISH_VERSION
	end
	printf '%s\n' $expected $actual | sort --check=silent --version-sort
	return $status
end

if __fish_version_gt "2.7.2"
	set mfish 1
end

bind \cr 'fzy_select_history'
if [ $mfish ]
	bind \cf 'fzy_select_file'
	bind \cg 'fzy_change_directory'
end

if bind -M insert > /dev/null 2>&1
	bind -M insert \cr 'fzy_select_history'
	if [ $mfish ]
		bind -M insert \cf 'fzy_select_file'
		bind -M insert \cg 'fzy_change_directory'
	end
end

set -e mfish

function misc_uninstall -e misc_uninstall
	bind -e \cr
	bind -M insert -e \cr
	bind -e \cf
	bind -M insert -e \cf
	bind -e \cg
	bind -M insert -e \cg
end

function fzy_select_history -d 'Fuzzy search the history'
	history | fzy -l 15 -q (commandline -b) | read -l result
	commandline -f repaint
	commandline -- $result
end

function fzy_select_file -d 'Insert file path into the commandline buffer'
	set -l commandline (__fzy_parse_commandline)
    set -l dir $commandline[1]
	set -l fzy_query $commandline[2]
	set -l fzy_args '-l 15'
	set -q search_cmd; or set -l search_cmd "
	command find -L $dir -mindepth 1 \\( "(__fzy_get_exclusion_pattern)" -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
	-o -type f -print \
	-o -type d -print \
	-o -type l -print \
	^/dev/null | command sed 's@^\./@@'"
	if [ -n $fzy_query ]
		set fzy_args "-l 15 -q $fzy_query"
	end
    begin
		eval "$search_cmd | fzy $fzy_args" | while read -l r; set result $result $r; end
	end
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

function fzy_change_directory -d "change directory"
    set -l commandline (__fzy_parse_commandline)
    set -l dir $commandline[1]
    set -l fzy_query $commandline[2]
	set -l fzy_args '-l 15'
    set -q search_cmd; or set -l search_cmd "
    command find -L $dir -mindepth 1 \\( "(__fzy_get_exclusion_pattern)" -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type d -print ^/dev/null | command sed 's@^\./@@'"
	if [ -n $fzy_query ]
		set fzy_args "-l 15 -q $fzy_query"
	end
    begin
		eval "$search_cmd | fzy $fzy_args" | read -l result
		if [ -n "$result" ]
			echo "$result"
			cd "$result"
			# Remove last token from commandline.
			commandline -t ""
		end
    end
    commandline -f repaint
end

function __fzy_get_exclusion_pattern
	set -l excluded_dirs .git .hg .svn .bzr .arch-ids
	set -l epar
	for i in $excluded_dirs
		set -a epar "-path \$dir'*$i' -o"
	end
	echo (string join ' ' -- $epar)
end

function __fzy_parse_commandline -d 'Parse the current command line token and return split of existing filepath and rest of token'
    # eval is used to do shell expansion on paths
    set -l commandline (eval "printf '%s' "(commandline -t))

    if [ -z $commandline ]
		# Default to current directory with no --query
		set dir '.'
		set fzy_query ''
    else
		set dir (__fzy_get_dir "$commandline")

		if [ "$dir" = "." -a (string sub -l 1 -- "$commandline") != '.' ]
			# if $dir is "." but commandline is not a relative path, this means no file path found
			set fzy_query "$commandline"
		else
			# Also remove trailing slash after dir, to "split" input properly
			set fzy_query (string replace -r "^$dir/?" '' -- "$commandline")
		end
    end

    echo "$dir"
    echo "$fzy_query"
end

function __fzy_get_dir -d 'Find the longest existing filepath from input string'
    set dir $argv

    # Strip all trailing slashes. Ignore if $dir is root dir (/)
    if [ (string length -- "$dir") -gt 1 ]
		set dir (string replace -r '/*$' '' -- "$dir")
    end

    # Iteratively check if dir exists and strip tail end of path
    while [ ! -d "$dir" ]
		# If path is absolute, this can keep going until ends up at /
		# If path is relative, this can keep going until entire input is consumed, dirname returns "."
		set dir (dirname -- "$dir")
    end

    echo "$dir"
end
