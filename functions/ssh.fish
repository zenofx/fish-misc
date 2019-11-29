function ssh
  set ps_res (ps -p (ps -p %self -o ppid= | xargs -n 1) -o comm=)
  if string match -q -- "tmux*" "$ps_res"
	set title (echo $argv | cut -d . -f 1)
	if [ -n $title ]
		tmux rename-window "{$title}"
		eval "command ssh $argv"
		tmux set-window-option automatic-rename "on" 1>/dev/null
	end
  else
    eval "command ssh $argv"
  end
end
