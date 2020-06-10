#!/bin/sh
set -ex

cd ${GITHUB_WORKFLOW}
ls -al

$(archbuild.py $@)

ls -l ~/{packages,sources,srcpackages,makepkglogs}
