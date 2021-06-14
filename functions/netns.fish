# vim: ft=fish ts=4 sw=4 noet
function netns --description 'launch application into network namespace'
	if command -sq firejail
		firejail --quiet --noprofile --netns=$argv[1] $argv[2..-1]
	else
		sudo -E ip netns exec $argv[1] setpriv --reuid (id -u) --regid (id -g) --clear-groups --reset-env $argv[2..-1]
	end
end
