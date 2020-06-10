#!/bin/sh

rm -rf ${GITHUB_WORKFLOW}
git checkout -- ${GITHUB_WORKFLOW}/{lilac.py,lilac.yaml}

cd ${GITHUB_WORKFLOW}

download-sources-from-aur.sh $1
