function fidle
  command ps -u $USER -o "pid,ppid,etime,ni,sched,policy,stat,tname,cmd" | command sk -m | while read -l pid _
    set pids $pids $pid
  end
  command schedtool -D -- $pids
end
