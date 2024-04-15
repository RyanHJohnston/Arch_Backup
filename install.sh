#!/bin/bash

PACMAN_PKGS=pacpkgs.txt
AUR_PKGS=aurpkgs.txt

# make sure to have all non-aur packages listed in aurpkgs.txt
# echo $(sudo pacman -Qn | cut -d ' ' -f 1) > $PACMAN_PKGS

# make sure to havell all aur packages listed in aurpkgs.txt 
# echo $(yay -Qm | cut -d ' ' -f 1) > $AUR_PKGS

# prereqs
PREREQ_PKGS=("neovim" "vim" "git" "htop" "net-tools" "openssh")
for pkg in "${PREREQ_PKGS[@]}";
do
    sudo pacman -S $pkg --noconfirm
    if ! pacman -Qq | grep -Fxq "$pkg"; 
    then
        printf "ERROR: $pkg failed to install.\n"
    fi
done


git clone https://aur.archlinux.org/yay.git
if ! ls -ali --color=auto | grep -i 'yay';
then
    printf "ERROR: Failed to clone yay repository.\n"
    exit 1
fi

YAY_DIR=$(readlink -f yay)
(cd $YAY_DIR && makepkg -sfi --noconfirm)
printf "\n\nDone building yay\n\n"

if ! pacman -Qq | grep -Fxq "yay";
then
    printf "ERROR: yay failed to build.\n"
    exit 1
fi

for pkg in $(cat $PACMAN_PKGS);
do
    printf "\n\nInstalling $pkg..."
    sudo pacman -S $pkg --noconfirm
done

for pkg in $(cat $AUR_PKGS);
do
    printf "\n\nInstalling $pkg..."
    yay -S $pkg --noconfirm
done


# install all flatpak packages from flatpak_installed_packages.txt
# cat flatpak_installed_packages.txt | xargs flatpak install -y
