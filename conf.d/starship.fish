if command -sq starship
	eval (command starship init fish)
else
	set SPACEFISH_PROMPT_ORDER time user dir host git package docker golang rust pyenv exec_time line_sep jobs exit_code char
	set SPACEFISH_EXEC_TIME_COLOR cyan
	set SPACEFISH_TIME_COLOR cyan
	set SPACEFISH_USER_COLOR cyan
end
