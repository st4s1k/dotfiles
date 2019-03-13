#!/bin/bash

if [ $(id -u) = 0 ]; then
	echo "ERROR: Running scripts as root may lead to damage or unpredictible behavior!"
	exit 1
fi	

# Get the current path relative to the this script
current_dir=$(temp=$(realpath "$0") && dirname "$temp") ;

printf "[1] Copy all configuration dotfiles into the Home directory ...\n" ;
cp -arf "$current_dir/dotfiles/." $HOME/ ;
printf "[1] done!\n" ;

printf "[2] Installing all packages from pkglist.txt ...\n" ;
sudo pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort $current_dir/pkglist.txt)) ;
printf "[2] done!\n" ;

printf "[3] Git clone \"yay\" AUR helper ...\n" ;
git clone https://aur.archlinux.org/yay.git $HOME/Downloads/yay ;
printf "[3] done!\n" ;

printf "[4] Install \"yay\" AUR helper ...\n" ;
cd $HOME/Downloads/yay ;
makepkg -si --noconfirm --needed ;
printf "[4] done!\n" ;

printf "[5] Cleaning up..." ;
rm -rf $HOME/Downloads/yay
# maybe will be more, later
printf "[5] done!\n" ;

printf "[5] Installing all packages from localpkglist.txt ...\n" ;
yay -S --noconfirm --needed $current_dir/localpkglist.txt ;
printf "[5] done!\n" ;

notify-send -u normal "Restore complete."
