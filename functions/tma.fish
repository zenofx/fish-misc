function tma --description 'attach to existing tmux session or create a new one'
	set -l sess 'main'
	if count $argv >/dev/null
		set sess "$argv[1]"
	end
	command tmux attach-session -t "$sess" || command tmux new-session -s "$sess"
end
