	function safe_launch --description 'launch command inside a protected tmux session'
        if ! command -sq tmux
            return 1
        end

		if ! command tmux has-session -t _safe_launch ^/dev/null
			if [ -z $TMUX ]
				command tmux start-server \
				&& command tmux new-session -s _safe_launch "$argv;bash -i"
			else
				command tmux new-session -d -s _safe_launch \
				&& command tmux new-window -k -t _safe_launch "$argv;bash -i" \
                && echo "created detached session '_safe_launch' to avoid nesting"
			end
		else
			if [ -z $TMUX ]
				command tmux new-window -t _safe_launch "$argv;bash -i" \
				&& command tmux attach-session -t _safe_launch
			else
				command tmux new-window -t _safe_launch "$argv;bash -i"
			end
		end
	end