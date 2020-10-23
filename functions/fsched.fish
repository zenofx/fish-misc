function fsched
    command ps -u $USER -o "pid,ppid,etime,ni,sched,policy,stat,tname,cmd" | command fzf -m | while read -l pid _
      set pids $pids $pid
    end
    eval schedtool (string escape -- $argv) $pids
end
