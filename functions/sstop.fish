function sstop --description 'stop systemd service and print status'
    sudo systemctl stop $argv; _sstatus $argv
end
