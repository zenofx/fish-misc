function ssh
  set ps_res (ps -p (ps -p %self -o ppid= | xargs -n 1) -o comm=)
  if string match -q -- "tmux*" "$ps_res"
	set title \
		(string split "." -- (
			string replace --regex -- '^(?:((?:[A-Za-z0-9_])+)\\@)?((?:[A-Za-z0-9_\\.])+)(?:\\:(\\/(?:[A-Za-z0-9_\\/]*))){0,1}$' '$2' (
			string split " " -r -m1 -- "$argv")[-1]
		))[1]
	if [ -n $title ]
		command tmux rename-window "{$title}"
		eval "command ssh $argv"
		command tmux set-option -w automatic-rename "on" 1>/dev/null
	end
  else
    eval "command ssh $argv"
  end
end