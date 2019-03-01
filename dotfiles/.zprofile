if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
PATH=$PATH:/usr/local/bin
