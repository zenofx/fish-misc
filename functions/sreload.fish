function sreload --description 'reload systemd service and print status'
    sudo systemctl reload $argv; _sstatus $argv
end