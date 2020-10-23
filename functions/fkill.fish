function fkill
    command ps -u $USER -o "pid,ppid,etime,stat,tname,cmd" | command fzf -m | while read -l pid _
      set pids $pids $pid
    end
    if string match --quiet --regex --invert '\D' $argv[1];
        kill "$argv[1]" -- $pids
    else
        kill -- $pids
    end
    return $status
end
