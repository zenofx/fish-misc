function sstatus --description 'print systemd service status'
    systemctl status -a $argv
end