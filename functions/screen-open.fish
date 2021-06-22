# vi:set ft=fish ts=4 sw=4 noet ai:
function screen-open --description "open last screenshot"
	xdg-open (find -H $HOME/Pictures/Screenshot*.png -maxdepth 1 -type f -exec stat --printf='%Y\0%n\n' -- {} + | sort -nr | awk -F"\0" 'NR==1 {print $2}')
end

