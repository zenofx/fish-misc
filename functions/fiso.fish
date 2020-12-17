function fiso
	command ps -u $USER -o "pid,ppid,etime,ni,sched,policy,stat,tname,cmd" | command fzf -m | while read -l pid _
		set pids $pids $pid
	end
	command schedtool -I -- $pids
end
