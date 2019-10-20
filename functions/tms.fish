function tms --description 'create basic tmux working layout'
	command tmux \
			rename-window -t 1 "sys" \; \
			new-window -d -c "$HOME" -t 2 \; \
			new-window -d -c "$HOME" -n "sh" -t 3 bash \; \
			new-window -d -c "$HOME" -n "mon" -t 4 \; \
			split-window -d -h -p 40 -t 4 \; \
			split-window -d -v -t 4 \; \
			new-window -d -c "$HOME" -n "run" -t 5 \; \
			new-window -d -c "$HOME" -n "div" -t 6 \; \
			new-window -d -c "$HOME" -n "{ssh1}" -t 7 \; \
			new-window -d -c "$HOME" -n "{ssh2}" -t 8 \; \
			new-window -d -c "$HOME" -n "{ssh3}" -t 9 \; \
			send-keys -t 1 'sudo -i' #C-m
	# clear highlights
	begin
		command fish -c 'sleep 1s; tmux kill-session -C' &
	end
end
