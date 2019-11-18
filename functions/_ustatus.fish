function _ustatus --description 'show status of a systemd user service'
    systemctl --user status -a -n0 $argv
end