#!/bin/sh
set -ex

pwd

for i in $(find . -type f -name '*.pkg.tar.zst')
do
	mv $i $(echo $i | sed 's/:/COLON/g')
done

clean-up.sh
