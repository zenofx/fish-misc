function _sstatus --description 'show status of a systemd system service'
    systemctl status -a -n0 $argv
end
