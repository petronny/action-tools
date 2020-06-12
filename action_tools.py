#!/usr/bin/env python3
import os
from lilaclib import *
from pathlib import Path
from lilac2.lilacyaml import load_lilac_yaml

def download_repo_depends(package=None):
    if package:
        path = Path('..') / package
    else:
        path = Path('.')

    repo_depends = []
    try:
        conf = load_lilac_yaml(path)
        if 'repo_depends' in conf:
            repo_depends = conf['repo_depends']
    except FileNotFoundError:
        pass

    for i in repo_depends:
        if type(i) is tuple:
            pkgbase, pkgname = i
        else:
            pkgbase, pkgname = i, i

        try:
            run_cmd(['download-package-from-artifact.sh', 'petronny/arch4edu', pkgbase, pkgname, '~/repo_depends'])
        except:
            run_cmd(['download-package-from-repo.sh', pkgbase, 'arch4edu', 'x86_64', '~/repo_depends'])

        download_repo_depends(i)

def action_main(build_prefix=None, build_args=None, makechrootpkg_args=None, makepkg_args=None):

    if makechrootpkg_args is None:
        makechrootpkg_args = []

    download_repo_depends()

    for i in Path('~/repo_depends').rglob('*.pkg.tar*'):
        makechrootpkg_args += ['-I', i]

    single_main(build_prefix=build_prefix, build_args=build_args, makechrootpkg_args=makechrootpkg_args, makepkg_args=makepkg_args)
