# vim: ft=fish ts=4 sw=4 noet
function nocomment --description 'strip comments and empty lines'
	awk '$1 ~ /^[^#]/'
end

