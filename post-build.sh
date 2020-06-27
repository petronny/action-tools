#!/bin/sh
set -ex

cd ~/arch4edu

for i in $(find . -type f -name '*.pkg.tar.xz')
do
	xz -d --stdout $i | zstd -c -T0 --ultra -20 -o ${i%xz}zst
done

for i in $(find . -type f -name '*.pkg.tar.zst')
do
	filename=$(basename $i)
	dirname=$(dirname $i)
	if [ $(echo $filename | grep : -c) -gt 0 ]
	then
		mv $dirname/$filename $dirname/$(echo $filename | sed 's/:/COLON/g')
	fi
done

clean-up.sh
