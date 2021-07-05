# vim: ft=fish ts=4 sw=4 noet
function safe_launch_extra --description 'launch command inside a dedicated tmux session'
	if ! command -sq tmux; return 1; end

	command tmux has-session -t '_safe_launch' >/dev/null 2>&1
	set -l sess $status

	if _is_tmux
		if [ "$sess" = 0 ] # has session
			command tmux new-window -t '_safe_launch' "$argv;bash -i"
		else
			command tmux new-session -d -s '_safe_launch' \
			&& command tmux new-window -k -t '_safe_launch' "$argv;bash -i" \
			&& echo "created detached session ''_safe_launch'' to avoid nesting"
		end
	else
		if [ "$sess" = 0 ] # session
			command tmux new-window -t '_safe_launch' "$argv;bash -i" \
			&& command tmux attach-session -t '_safe_launch'
		else
			command tmux start-server \
			&& command tmux new-session -s '_safe_launch' "$argv;bash -i"
		end
	end
end
