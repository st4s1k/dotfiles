#!/bin/sh

if [ $(id -u) -eq 0 ]; then
	printf "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi

# Get current script location
current_dir=$(temp=$(realpath "$0") && dirname "$temp")

printf "Saving configuration files to: $current_dir\n"

printf "[1] Copying dotfiles ...\n"

pacman -Qi rsync >/dev/null 2>&1
if [ $? -eq 1 ]; then
	msg="[1] Missing 'rsync', using 'cp' ..."
	notify-send -u normal $msg
	sync_tool="cp -a"
else
	msg="[1] Found 'rsync'. Using 'rsync' ..."
	# notify-send -u normal $msg
	sync_tool="rsync -a --relative"
fi

echo $msg

mkdir $current_dir/dotfiles >/dev/null 2>&1

if [ "$sync_tool" ]; then
	$sync_tool \
		$HOME/./.zshrc.local \
		$HOME/./.vimrc \
		$HOME/./.Xresources \
		$HOME/./.compton.conf \
		$HOME/./.wallpaper.jpg \
		$HOME/./.config/dunst/ \
		$HOME/./.config/i3/ \
		$HOME/./.config/polybar/ \
		$HOME/./.config/ranger/ \
		$HOME/./.config/rofi/ \
		$HOME/./.scripts/ \
		$HOME/./.icons/ \
		$HOME/./.fonts/ \
		$HOME/./.urxvt/ \
		$HOME/./.ssh/ \
		$current_dir/dotfiles/ &&
		printf "[1] done!\n" || printf "[1] failed!\n"
fi

cd $current_dir/dotfiles

find . | cut -sd / -f 2- >$current_dir/dotfiles.txt

printf "[2] Saving installed official repository package list ...\n"
pacman -Qqen >$current_dir/pkglist.txt &&
	printf "[2] done!\n" || printf "[2] failed!\n"

printf "[3] Saving installed AUR package list ...\n"
pacman -Qqem >$current_dir/localpkglist.txt &&
	printf "[3] done!\n" || printf "[3] failed!\n"

printf "[4] Saving modified system config files ...\n"

mkdir $current_dir/root >/dev/null 2>&1

$sync_tool $(pacman -Qii | awk '/^MODIFIED/ {print $2}') $current_dir/root &&
	# pacman -Qii | awk '/^MODIFIED/ {print $2}' | tar -P -n -cvzf $current_dir/modified_cfg_files.tz -T - >/dev/null &&
	printf "[4] done!\n" || printf "[4] failed!\n"

notify-send -u normal "Backup complete."
printf "Backup complete.\n"
