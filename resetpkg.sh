#!/bin/sh

if [ $(id -u) -eq 0 ]; then
	echo "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi

# Get current script location
current_dir=$(temp=$(realpath "$0") && dirname "$temp")

printf "Removing packages that are not in pkglist.txt ...\n"
sudo pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort $current_dir/pkglist.txt)) &&
	printf "done!\n" || printf "failed!\n"

notify-send -u normal "Reset complete."
