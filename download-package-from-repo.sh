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

pacman -Sw $package --arch $arch --config $pacman_conf --dbpath $dbpath --gpgdir $gpgdir --cachedir $path
