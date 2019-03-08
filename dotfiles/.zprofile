if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
PATH=$PATH:/usr/local/bin

XDG_CONFIG_HOME=$XDG_CONFIG_HOME:/$HOME/.config
XDG_CACHE_HOME=$XDG_CACHE_HOME:/$HOME/.cache
XDG_DATA_HOME=$XDG_DATA_HOME:/$HOME/.local/share

XDG_DATA_DIR=$XDG_DATA_DIR:/usr/local/share
XDG_DATA_DIR=$XDG_DATA_DIR:/usr/share

XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS:/etc/xdg
