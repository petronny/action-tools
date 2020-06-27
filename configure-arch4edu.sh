#!/bin/sh
set -e

mkdir -p ~/pacman/arch4edu/db
cd ~/pacman/arch4edu

[ ! -d gnupg ] && fakeroot pacman-key --gpgdir gnupg --init

pacman-key --gpgdir gnupg -l 7931B6D628C8D3BA && imported=1

if [ -z "$imported" ]
then
	if [ -f /usr/share/pacman/keyrings/arch4edu-trusted ]
	then
		sudo pacman-key --populate arch4edu
	else
		sudo pacman-key --gpgdir gnupg --recv-keys 7931B6D628C8D3BA
		sudo pacman-key --gpgdir gnupg --finger 7931B6D628C8D3BA
		sudo pacman-key --gpgdir gnupg --lsign-key 7931B6D628C8D3BA
	fi
fi

if [ ! -f pacman.conf ]
then
	echo [options] > pacman.conf
	pacman-conf | grep '^Architecture' >> pacman.conf
	echo [arch4edu] >> pacman.conf
	sed 's/#//' ${GITHUB_WORKSPACE}/mirrorlist/mirrorlist.arch4edu >> pacman.conf
fi

sudo pacman -Sy --config pacman.conf --dbpath db --noprogressbar
