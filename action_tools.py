#!/usr/bin/env python3
import sys
import logging
import traceback
from lilaclib import *
from pathlib import Path
from lilac2.lilacyaml import load_lilac_yaml

def download_repo_depends(package=None):

    if package:
        if type(package) is tuple:
            path = Path('..') / package[0]
        else:
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
            run_cmd(['download-file-from-artifact.zsh',
                '--repo', 'petronny/arch4edu',
                '--file', pkgbase,
                '--type', 'package',
                '--pkgname', pkgname,
                '--save-path', '~/repo_depends'])
        except:
            logging.error(traceback.print_exc())
            run_cmd(['download-package-from-repo.sh', pkgname, 'arch4edu', 'x86_64', '~/repo_depends'])

        download_repo_depends(i)

def action_main(build_prefix, build_args=None, makechrootpkg_args=None, makepkg_args=None):
    if len(sys.argv) < 2 or sys.argv[1] != 'action':
        logging.warning('Not in action mode. Falling back to single_main')
    else:
        if makechrootpkg_args is None:
            makechrootpkg_args = []

        download_repo_depends()

        for i in Path('~/repo_depends').rglob('*.pkg.tar*'):
            makechrootpkg_args += ['-I', i]

        if 'action-' in build_prefix:
            build_prefix = build_prefix[build_prefix.find('action-')+len('action-'):]

    single_main(build_prefix=build_prefix, build_args=build_args, makechrootpkg_args=makechrootpkg_args, makepkg_args=makepkg_args)
