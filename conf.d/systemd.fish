# vim: ft=fish ts=4 sw=4 noet
# user has to explicitly set SYSTEMD_PAGER or we override it
if begin; ! set -q SYSTEMD_PAGER; or [ $SYSTEMD_PAGER = 'cat' ]; end; and type -f bat >/dev/null 2>&1
    set -gx SYSTEMD_PAGER 'bat'
end

# useful abbreviations
abbr -a -g -- cgls systemd-cgls
abbr -a -g -- cgtop systemd-cgtop
abbr -a -g -- sda systemd-analyze
abbr -a -g -- jcs 'sudo journalctl --system'
abbr -a -g -- jcu 'journalctl --user'
abbr -a -g -- scu 'systemctl --user'
abbr -a -g -- scs 'sudo systemctl --system'
abbr -a -g -- sculu 'systemctl --user list-unit-files --state=enabled'
abbr -a -g -- scslu 'systemctl --system list-unit-files --state=enabled'

