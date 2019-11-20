function fish_greeting
	# caching
	set -l now (date '+%s')
	set -l stale false
	set -l caching_time 30
	
	if ! set -q FISH_GREETING_EPOCH
		echo "setting EPOCH"
		set -Ux FISH_GREETING_EPOCH $now
		echo "epoch: $FISH_GREETING_EPOCH"
	end

	set -l diff (math "$now-$FISH_GREETING_EPOCH")
	if [ $diff -gt $caching_time ]
		set FISH_GREETING_EPOCH $now
		set stale true
	end
	
	if [ -d $XDG_CACHE_HOME ]
		set buf "$XDG_CACHE_HOME/fish_greeting"
	else
		set buf "$HOME/.cache/fish_greeting"
	end

	if ! $stale
		cat "$buf"
		echo "printing cache"
		return
	end

	# pass multiline string as single argument to printf
	set -e IFS

	printf -- '\n%b\n%b\n%b\n\n' \
		(uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}') \
		(uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}') \
		(uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}') > "$buf"

	printf -- '%b\n%b\n\n' \
		" \\e[1mDisk usage:\\e[0m" \
		(df -lh --output=source,target,iused,iavail,ipcent | \
		grep -E 'dev/(xvda|sd|mapper)' | \
		tail -n +2 | \
		column -t -N source,path,used,avail,percent -T path -H source | \
		sed -e '1 s/^\(.*\)$/\\\\e[1m\1\\\\e[0m/
			s/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/
			s/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/
			s/^/\t/') >> "$buf"

	# http://tdt.rocks/linux_network_interface_naming.html
	printf -- '%b\n%b\n' \
		'\\e[1mNetwork:\\e[0m' \
		(ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed \
				-e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {printf "%s %s\n", i, $0; next} // {i = $0}' | \
			sort | \
			column -t -R1 | \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/
            # private addresses are not \
			s/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/
            # ULA are private as well
            s/m\(fd[[:alnum:]][[:alnum:]]\:.*\)/m\\\e[24m\1/
            # unknown interfaces are cyan
			s/^\( *[^ ]\+\)/\\\e[36m\1/
            # virtual interfaces are blue
            s/\(\(vir\|cn\)[^ ]* .*\)/\\\e[34m\1/
            # ethernet interfaces are normal
			s/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/
            # wireless interfaces are purple
			s/\(wl[^ ]* .*\)/\\\e[35m\1/
            # wwan interfaces are yellow
			s/\(ww[^ ]* .*\).*/\\\e[33m\1/
			s/$/\\\e[0m/
			s/^/\t/') >> "$buf"

	cat "$buf"
	set_color normal
end
