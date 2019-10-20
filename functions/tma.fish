function tma --description 'attach to existing tmux session or create a new one'
	set -l sess 'main'
	if count $argv >/dev/null
		set sess "$argv[1]"
	end
	# work around a weird bug with "los server" when using fish to spawn a new session using brute force
	command tmux attach-session -t "$sess" || begin
		set limit 10
		while ! tmux new-session -s "main" ^/dev/null; and test $limit -gt 0
			set limit (math $limit - 1)
			echo $limit
		end
		set -e limit
	end
end