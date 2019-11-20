function sstop --description 'stop systemd user service and print status'
    systemctl --user stop $argv; _ustatus $argv
end
