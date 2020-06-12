#!/bin/sh
set -ex

repo=$1
file=$2
path=$3

artifact_id=$(curl "https://api.github.com/repos/${repo}/actions/artifacts" |
	jq ".artifacts | .[] | select(.name==\"${file}\") | .id" |
	head -n1)

[ -z "$artifact_id" ] && exit 1

mkdir -p $path
cd $path

set +x
curl -L "https://api.github.com/repos/$repo/actions/artifacts/$artifact_id/zip" \
	-H "Accept: application/vnd.github.everest-preview+json" \
	-H "Authorization: token $TOKEN" |
	bsdtar -xvf - -O > $file
set -x
