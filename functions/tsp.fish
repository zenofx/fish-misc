function tsp
	set -x S_SOCKET "$XDG_RUNTIME_DIR/tsp/socket-ts."(id -u)
	set -x TMPDIR "$XDG_RUNTIME_DIR/tsp"
	eval "command tsp $argv"
end