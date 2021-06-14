# vim: ft=fish ts=4 sw=4 noet
function fidle
	command ps -u $USER -o "pid,ppid,etime,ni,sched,policy,stat,tname,cmd" | command fzf -m | while read -l pid _
		set pids $pids $pid
	end
	command schedtool -D -- $pids
end
