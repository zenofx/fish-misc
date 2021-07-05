# vim: ft=fish ts=4 sw=4 noet
function fish_greeting
	if ! set -q fish_greeting; or [ -z $fish_greeting ]
		return
	end

	# caching
	set now (date '+%s')
	set stale false
	set caching_time 600
	
	if ! set -q FISH_GREETING_EPOCH
		set -U FISH_GREETING_EPOCH $now
		set stale true
	end

	set -l diff (math "$now-$FISH_GREETING_EPOCH")
	if [ $diff -gt $caching_time ]
		set -U FISH_GREETING_EPOCH $now
		set stale true
	end
	
	if [ -d $XDG_RUNTIME_DIR ]
		set buf "$XDG_RUNTIME_DIR/fish_greeting"
	else
		set buf "/run/user/"(id -u)"/fish_greeting"
	end

	if ! $stale; and [ -f $buf ]
		cat $buf
		printf "\nCached at %s\n" (date -d @"$FISH_GREETING_EPOCH")
		return
	end

	# pass multiline string as single argument to printf
	# shadow IFS
	set -l IFS

	printf -- '\n%b\n%b\n%b\n\n' \
		(uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}') \
		(uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}') \
		(uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}') > "$buf"

	printf -- '%b\n%b\n\n' \
		" \\e[1mDisk usage:\\e[0m" \
		(df -lh --output=source,target,used,avail,pcent 2>/dev/null | \
		grep -E 'dev/(xvda|sd|mapper)' | \
#		tail -n +2 | \
		column -t -N source,path,used,avail,percent -T path -H source | \
		sed -e '1 s/^\(.*\)$/\\\\e[1m\1\\\\e[0m/
			s/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/
			s/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/
			s/^/\t/') >> "$buf"

	# http://tdt.rocks/linux_network_interface_naming.html
	printf -- '%b\n%b\n' \
		' \\e[1mNetwork:\\e[0m' \
		(ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed -e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {printf "%s %s\n", i, $0; next} // {i = $0}' | \
			sort | \
			column -t -R1 | \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/
				# private addresses are not \
				s/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/
				# ULAs are private as well
				s/m\(fd[[:alnum:]][[:alnum:]]\:.*\)/m\\\e[24m\1/
				# unknown, cyan
				s/^\( *[^ ]\+\)/\\\e[36m\1/
				# virtual, blue
				s/\(\(vir\|cn\)[^ ]* .*\)/\\\e[34m\1/
				# ethernet, white
				s/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/
				# wifi, purple
				s/\(wl[^ ]* .*\)/\\\e[35m\1/
				# wwan, yellow
				s/\(ww[^ ]* .*\).*/\\\e[33m\1/
				s/$/\\\e[0m/
				s/^/\t/') >> "$buf"

	cat $buf
	set_color normal
end
