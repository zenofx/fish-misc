function _istmux --description 'returns true if run inside tmux session'
    set -l ps_res (ps -p (ps -p %self -o ppid= | xargs -n 1) -o comm=)
    if string match -q -- "tmux*" "$ps_res"
        return 0
    end
    return 1
    # set -l tsock (string split ',' "$TMUX")
    # if ! [ -S "$tsock[1]" ] # we are not attached
    # end
end