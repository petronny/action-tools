#!/bin/sh
set -ex

cd ${GITHUB_WORKFLOW}
ls -al

$(archbuild.py $@) 1>~/build.log 2>&1

ls -l ~/{packages,sources,srcpackages,makepkglogs}
