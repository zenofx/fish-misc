# vim: ft=fish ts=4 sw=4 noet
function vim --description 'alias vim to nvim with its own scope'
	if command -sq nvim
		set cmd 'systemd-run --quiet --user --collect --scope nvim'
		_tmux_rename_window  $cmd 'vim' $argv
	else
		return 1
	end
end
