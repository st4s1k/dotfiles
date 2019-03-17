#!/bin/bash

if [ $(id -u) -eq 0 ]; then
	echo "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi

# Get current script location
current_dir=$(temp=$(realpath "$0") && dirname "$temp")

printf "[1] Installing required/missing packages from pkglist.txt ...\n"
sudo pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort $current_dir/pkglist.txt)) &&
	printf "[1] done!\n" || printf "[1] failed!\n"

printf "[2] Copying all configuration dotfiles into the Home directory ...\n"
rsync -a "$current_dir/dotfiles/." $HOME/ &&
	printf "[2] done!\n" || printf "[2] failed!\n"

printf "[3] Git clone \"yay\" AUR helper ...\n"
git clone https://aur.archlinux.org/yay.git $HOME/Downloads/yay &&
	printf "[3] done!\n" || printf "[3] failed!\n"

printf "[4] Install \"yay\" AUR helper ...\n"
cd $HOME/Downloads/yay
makepkg -si --noconfirm --needed &&
	printf "[4] done!\n" || printf "[4] failed!\n"

printf "[5] Cleaning up ..."
rm -rf $HOME/Downloads/yay &&
	printf "[5] done!\n" || printf "[5] failed!\n"

printf "[5] Installing all packages from localpkglist.txt ...\n"
yay -S --noconfirm --needed $current_dir/localpkglist.txt &&
	printf "[5] done!\n" || printf "[5] failed!\n"

notify-send -u normal "Restore complete."
