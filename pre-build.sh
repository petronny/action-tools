#!/bin/sh
set -ex

cp -r ${GITHUB_WORKSPACE}/arch4edu ~
chown -R pkgbuild:root ~
