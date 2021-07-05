# vim: ft=fish ts=4 sw=4 noet
function safe_launch --description 'launch command inside a tmux session'
	if ! command -sq tmux; return 1; end

	if _is_tmux
		command tmux new-window "$argv;bash -i"
	else
		if command tmux has-session -t 'main' >/dev/null 2>&1
			command tmux new-window -t 'main' "$argv;bash -i" \
			&& command tmux attach-session -t 'main'
		else
			command tmux new-session -A -s 'main' "$argv;bash -i"
		end
	end
end
