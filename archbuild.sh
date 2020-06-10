#!/bin/sh
set -ex
cd ${GITHUB_WORKFLOW}
command=$(archbuild.py $@)
echo $command
$command
ls -l ~/{packages,sources,srcpackages,makepkglogs}
