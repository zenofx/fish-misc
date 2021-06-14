# vim: ft=fish ts=4 sw=4 noet
# user has to explicitly set SYSTEMD_PAGER or we override it
if begin; ! set -q SYSTEMD_PAGER; or [ $SYSTEMD_PAGER = 'cat' ]; end; and type -f bat >/dev/null 2>&1
    set -gx SYSTEMD_PAGER 'bat'
end

