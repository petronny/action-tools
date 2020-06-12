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
