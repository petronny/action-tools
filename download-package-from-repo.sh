#!/bin/sh
set -ex

package=$1
repo=$2
arch=$3
path=$4

repo=~/pacman/$repo
pacman_conf=$repo/pacman.conf
dbpath=$repo/db
gpgdir=$repo/gnupg
pacman="fakeroot pacman --arch $arch --config $pacman_conf --dbpath $dbpath --gpgdir $gpgdir --cachedir $path --noconfirm"
depends=$(LANG=C $pacman -Si $package | sed -n '/^Depends/{s/^.*://;p}')

for i in $depends
do
	assume_installed+="--assume-installed $i"
done

$pacman -Sw $package $assume_installed
