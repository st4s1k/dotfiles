#!/bin/sh

current_dir=$(temp=$( realpath "$0"  ) && dirname "$temp")

echo "Saving configuration files to: $current_dir"

cp -rf \
~/.zshrc.local \
~/.vimrc \
~/.Xresources \
~/.compton.conf \
~/.wallpaper.jpg \
~/.config/ \
~/.scripts/ \
~/.icons/ \
~/.fonts/ \
~/.urxvt/ \
~/.ssh/ \
$current_dir/dotfiles/ ;

pacman -Qqen > $current_dir/pkglist.txt ;

pacman -Qqem > $current_dir/localpkglist.txt ;

pacman -Qii | awk '/^MODIFIED/ {print $2}' | tar -n -cvzf $current_dir/modified_cfg_files.tz -T - > /dev/null ;
