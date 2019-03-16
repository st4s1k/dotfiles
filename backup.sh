#!/bin/sh

if [ $(id -u) = 0 ]; then
	printf "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi

current_dir=$(temp=$(realpath "$0") && dirname "$temp")

printf "Saving configuration files to: $current_dir\n"

printf "[1] Copying dotfiles...\n"
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
$current_dir/dotfiles/
printf "[1] done!\n"

printf "[2] Saving installed official repository package list ...\n"
pacman -Qqen > $current_dir/pkglist.txt
printf "[2] done!\n"

printf "[3] Saving installed AUR package list ...\n"
pacman -Qqem > $current_dir/localpkglist.txt
printf "[3] done!\n"

printf "[4] Saving modified system config files...\n"
pacman -Qii | awk '/^MODIFIED/ {print $2}' | tar -n -cvzf $current_dir/modified_cfg_files.tz -T - > /dev/null
printf "[4] done!\n"

notify-send -u normal "Backup complete."
printf "Backup complete.\n"
