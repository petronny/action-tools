#!/bin/sh
set -ex

cd ${GITHUB_WORKFLOW}
ls -al

[ -z "$makepkg_args"] && makepkg_args='--nocheck'

${build_prefix}-build \
	${archbuild_args} --\
	-U pkgbuild ${makechrootpkg_args} -- \
	--noprogressbar ${makepkg_args} \
	1>~/build.log 2>&1

ls -l ~/{packages,sources,srcpackages,makepkglogs}
