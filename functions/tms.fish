function tms --description 'create basic tmux working layout'
	if ! _istmux
		# we only modify main *or* the currently attached session
		set session 'main'
		#  we cannot use new-session -A because we are not allowed to block here
		if ! command tmux has-session "$session" >/dev/null 2>&1
			command tmux new-session -d -s "$session" "bash -i"
		end	
	end
	command tmux \
			#rename-window -t "$session:1" "sys" \; \
			new-window -d -c "$HOME" -t "$session:2" \; \
			new-window -d -c "$HOME" -t "$session:3" \; \
			new-window -d -c "$HOME" -t "$session:4" \; \
			new-window -d -c "$HOME" -n "run" -t "$session:5"
#			new-window -d -c "$HOME" -n "mon" -t "$session:10" \; \
#			split-window -d -h -p 40 -t "$session:10" \; \
#			split-window -d -v -t "$session:10"
#			new-window -d -c "$HOME" -n "{ssh1}" -t "$session:7" \; \
#			new-window -d -c "$HOME" -n "{ssh2}" -t "$session:8" \; \
#			new-window -d -c "$HOME" -n "{ssh3}" -t "$session:9"
#			send-keys -t "$session:1" 'sudo -i' #C-m

	# _clear_highlights
	begin # suppress job control message
		# no subshell capability, no simple double fork
		# (sleep 60 &)
		# ((exec sleep 60)&)
		# use setsid or disown instead
		command setsid bash -c 'sleep 1s; tmux kill-session -C' &
	end

	# lastly we attach
	if [ -n "$session" ]
		command tmux attach-session -d -t "$session"
	end
end
