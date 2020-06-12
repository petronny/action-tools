#!/bin/sh
set -ex

repo=$1
pkgbase=$2
pkgname=$3
path=$4
type=$5

mkdir -p $path
cd $path

bsdtar tf $pkgbase.zip || rm -f $pkgbase.zip

if [ ! -f $pkgbase.zip ]
then
	download-file-from-artifact.sh $repo $pkgbase.zip $path
fi

package=$(bsdtar tf ${pkgbase}.zip |
	sed 's/COLON/:/g' |
	grep -P "^${pkgname}-[0-9.:-]*-(x86_64|armv6h|armv7h|aarch64|any)\.pkg\.tar.*" |
	sed 's/:/COLON/g')

[ -z "$package" ] && exit 1

bsdtar xvf ${pkgbase}.zip $package

if [ $(echo $package | grep COLON -c) -gt 0 ]
then
	mv $package $(echo $package | sed 's/COLON/:/g')
fi
