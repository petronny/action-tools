#!/bin/sh

mkdir -p ~/pacman/arch4edu/db
cd ~/pacman/arch4edu

git clone https://github.com/arch4edu/mirrorlist
git clone https://github.com/arch4edu/arch4edu-keyring keyring

cp keyring/* /usr/share/pacman/keyrings/

pacman-key --gpgdir gnupg --init
pacman-key --gpgdir gnupg --populate arch4edu

echo [options] > pacman.conf
pacman-conf | grep '^Architecture' >> pacman.conf
echo [arch4edu] >> pacman.conf
sed 's/#//' mirrorlist/mirrorlist.arch4edu >> pacman.conf

pacman -Sy --config pacman.conf --dbpath db
