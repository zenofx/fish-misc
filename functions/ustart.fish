function cgls --description 'starts systemd user service and print status'
    systemctl --user start $argv; _ustatus $argv
end
