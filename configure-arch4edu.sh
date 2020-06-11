#!/bin/sh
cp keyring/* /usr/share/pacman/keyrings/

pacman-key --gpgdir ~/pacman/arch4edu/gnupg --init
pacman-key --gpgdir ~/pacman/arch4edu/gnupg --populate arch4edu

mkdir -p ~/pacman/arch4edu
sed \
	-e '/^Include/d' \
	-e '/^\[core\]/d' \
	-e '/^\[extra\]/d' \
	-e '/^\[community\]/d' \
	-e '/^\[multilib\]/d' \
	/etc/pacman.conf > ~/pacman/arch4edu/pacman.conf
echo [arch4edu] >> ~/pacman/arch4edu/pacman.conf
sed 's/#//' ~/mirrorlist/mirrorlist.arch4edu >> ~/pacman/arch4edu/pacman.conf

pacman -Sy --config ~/pacman/arch4edu/pacman.conf --dbpath ~/pacman/arch4edu/db
