# vi:set ft=fish ts=4 sw=4 noet ai:
function _tmux_rename_window
	set cmd $argv[1]
	set title $argv[2]
	set param $argv[3..]

	# no rename when splits exist
	set panes (command tmux display-message -p '#{window_panes}')
	if [ $panes -gt 1 ]
		eval "command $cmd $param"
		return
	end

	function __tmux_pty_to_pane_id -a tty
		for pane in (tmux list-panes -aF "#{pane_tty}:#{pane_id}")
			set tok (string split ':' -- $pane)
			set pty $tok[1]
			set pid $tok[2]
			if [ $tty = $pty ]
				echo $pid
			end
		end
	end

	set pane_id (__tmux_pty_to_pane_id (tty))
	if [ -z $pane_id ]
		eval "command $cmd $param"
		return
	end

	command tmux rename-window -t "$pane_id" "$title"
	eval "command $cmd $param"
	command tmux set-option -qwp -t "$pane_id" automatic-rename "on"
end

