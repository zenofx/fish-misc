function ureload --description 'reload systemd user service and print status'
    systemctl --user reload $argv; _ustatus $argv
end