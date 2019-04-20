function fzy_select_history
	if test (count $argv) = 0
		set fzy_flags
	else
		set fzy_flags -q "$argv"
	end
	history | fzy -l 15 $fzy_flags | read -l result
	commandline -f repaint
	commandline -- $result
end
