#!/bin/sh
set -ex

repo=$1
pkgbase=$2
pkgname=$3
path=$4

artifact_id=$(curl "https://api.github.com/repos/${repo}/actions/artifacts" |
	jq ".artifacts | .[] | select(.name==\"${pkgbase}\") | .id" |
	head -n1)

[ -z "$artifact_id" ] && exit 1

mkdir -p $path
cd $path

bsdtar tf $pkgbase.zip || rm -f $pkgbase.zip

if [ ! -f $pkgbase.zip ]
then
	set +x
	curl -L "https://api.github.com/repos/$repo/actions/artifacts/$artifact_id/zip" \
		-H "Accept: application/vnd.github.everest-preview+json" \
		-H "Authorization: token $TOKEN" \
		-o $pkgbase.zip
	set -x
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
