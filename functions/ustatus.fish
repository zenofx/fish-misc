function ustatus --description 'show status of a systemd user service'
    systemctl --user status -a $argv
end