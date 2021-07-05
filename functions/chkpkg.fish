# vi:set ft=fish ts=4 sw=4 noet ai:
function chkpkg --description "check for new fedora packages"
	if not command -sq koji
		return
	end
	function _isnum
		test (math "0+$argv[1]" 2>/dev/null)
	end
	set -l days 2
	set -l packages $argv
	if _isnum $argv[1]
		set days $argv[1]
		set packages $argv[2..-1]
	end
	for package in $packages
		echo "Checking package: $package"
		koji list-builds --state=COMPLETE --after=(env LC_ALL=C date -d '-'$days' days') --package $package; 
	end
end

