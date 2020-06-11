#!/bin/sh
cp keyring/* /usr/share/pacman/keyrings/
pacman-key --populate arch4edu

mkdir -p ~/pacman
cp /etc/pacman.conf ~/pacman/pacman.conf.arch4edu
echo [arch4edu] >> ~/pacman/pacman.conf.arch4edu
sed 's/#//' -i ~/mirrorlist/mirrorlist.arch4edu >> ~/pacman/pacman.conf.arch4edu
