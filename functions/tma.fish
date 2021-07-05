# vim: ft=fish ts=4 sw=4 noet
function tma --description 'attach to existing tmux session or create a new one'
	set -l sess 'main'
	if count $argv >/dev/null
		set sess $argv[1]
	end
	# work around a weird bug with "los server" when using fish to spawn a new session using brute force
	command tmux new-session -A -s $sess -t 'primary'
end
