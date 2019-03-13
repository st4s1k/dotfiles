#!/bin/sh

if [ $(id -u) = 0 ]; then
	echo "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi

current_dir=$(temp=$(realpath "$0") && dirname "$temp") ;

echo "Saving configuration files to: $current_dir" ;

cp -rf \
$HOME/.zshrc.local \
$HOME/.vimrc \
$HOME/.Xresources \
$HOME/.compton.conf \
$HOME/.wallpaper.jpg \
$HOME/.config/ \
$HOME/.scripts/ \
$HOME/.icons/ \
$HOME/.fonts/ \
$HOME/.urxvt/ \
$HOME/.ssh/ \
$current_dir/dotfiles/ ;

pacman -Qqen > $current_dir/pkglist.txt ;

pacman -Qqem > $current_dir/localpkglist.txt ;

pacman -Qii | awk '/^MODIFIED/ {print $2}' | tar -n -cvzf $current_dir/modified_cfg_files.tz -T - > /dev/null ;

notify-send -u normal "Backup complete."
