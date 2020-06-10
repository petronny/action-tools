#!/bin/sh
set -e

rm -rf ${GITHUB_WORKFLOW}

for i in lilac.py lilac.yaml
do
	git checkout -- ${GITHUB_WORKFLOW}/${i} || ;
done

cd ${GITHUB_WORKFLOW}

download-sources-from-aur.sh $1
