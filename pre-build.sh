#!/bin/sh
set -ex

cp -r ${GITHUB_WORKSPACE}/arch4edu ~

cd ~/arch4edu
git config user.email "calil@jingbei.li"
git config user.name "calil"

chown -R pkgbuild:root ~
