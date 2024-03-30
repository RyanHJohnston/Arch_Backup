#!/bin/bash

# install all packages from installed_packages.txt
# sudo pacman -S --needed $(cat installed_packages.txt) --noconfirm
yay -S --needed $(cat installed_packages.txt) --noconfirm

# install all flatpak packages from flatpak_installed_packages.txt
cat flatpak_installed_packages.txt | xargs flatpak install -y
