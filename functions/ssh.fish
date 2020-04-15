function ssh --description 'sets tmux window title to ssh remote hostname'
  if _istmux
	set dest (string split " " -r -m1 -- "$argv")[-1]
	set host (string replace -i --regex -- '^(?:((?:[a-z_](?:[a-z0-9_-]{0,31}|[a-z0-9_-]{0,30})?))\@)?((?:[a-z0-9]+[a-z0-9\-\.\:]*[a-z0-9]+)+)$' '$2' "$dest")

	if not string match -qr '^[0-9\.]+$' "$host"
		# DNS/IPv6, only display host part *or* full IPv6
		set title (string split '.' -- "$host")[1]
	else
		# IPv4, display fully
		set title "$host"
	end

	if [ -z $title ]
		set title "$dest"
	end

	command tmux rename-window "{$title}"
	eval "command ssh $argv"
	command tmux set-option -w automatic-rename "on" 1>/dev/null
  end
end