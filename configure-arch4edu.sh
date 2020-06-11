#!/bin/sh
cp ${GITHUB_WORKSPACE}/keyring/* /usr/share/pacman/keyrings/

mkdir -p ~/pacman/arch4edu/db
cd ~/pacman/arch4edu

pacman-key --gpgdir gnupg --init
pacman-key --gpgdir gnupg --populate arch4edu

sed \
	-e '/^Include/d' \
	-e '/^\[core\]/d' \
	-e '/^\[extra\]/d' \
	-e '/^\[community\]/d' \
	-e '/^\[multilib\]/d' \
	/etc/pacman.conf > pacman.conf
echo [arch4edu] >> pacman.conf
sed 's/#//' ${GITHUB_WORKSPACE}/mirrorlist/mirrorlist.arch4edu >> pacman.conf

pacman -Sy --config pacman.conf --dbpath db
