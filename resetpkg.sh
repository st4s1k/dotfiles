#!/bin/sh

if [ $(id -u) = 0 ]; then
	echo "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi

current_dir=$(temp=$(realpath "$0") && dirname "$temp")

sudo pacman -Rsu $(comm -23 <(pacman -Qq|sort) <(sort $current_dir/pkglist.txt))

notify-send -u normal "Reset complete."
