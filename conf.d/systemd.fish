# user has to explicitly set SYSTEMD_PAGER or we override it
if begin; ! set -q SYSTEMD_PAGER; or [ $SYSTEMD_PAGER = 'cat' ]; end; and type -f bat >/dev/null 2>&1
    set -gx SYSTEMD_PAGER 'bat'
end

abbr -ag senable 'sudo systemctl enable'
abbr -ag sdisable 'sudo systemctl disable'
abbr -ag slist 'systemctl list-units -t path,service,socket --no-legend'
abbr -ag uctl 'systemctl --user'
abbr -ag sctl 'systemctl'
abbr -ag ulist 'systemctl --user list-units -t path,service,socket --no-legend'
abbr -ag ssession 'loginctl session-status $XDG_SESSION_ID'
abbr -ag stree 'tree /etc/systemd/system'

# add autoload functions for abbr -l visibility
abbr -ag cgls cgls
abbr -ag usls usls
abbr -ag ustart ustart
abbr -ag ustop ustop
abbr -ag ureload ureload
abbr -ag sreload sreload
abbr -ag ustatus ustatus
abbr -ag sstart sstart
abbr -ag sstop sstop
abbr -ag sstatus sstatus