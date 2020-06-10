#!/bin/sh
set -ex

rm -rf ${GITHUB_WORKFLOW}

for i in lilac.py lilac.yaml
do
	git checkout -- ${GITHUB_WORKFLOW}/${i} || echo
done

cd ${GITHUB_WORKFLOW}

download-sources-from-aur.sh $1
