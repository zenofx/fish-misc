function sstart --description 'starts systemd service and print status'
    sudo systemctl start $argv; _sstatus $argv
end