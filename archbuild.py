#!/bin/python
import argparse

parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('--build_prefix',
        default='extra-x86_64',
        help="Build prefix for archbuild. Default is 'extra-x86_64'.")
parser.add_argument('--archbuild_args',
        help="Extra parameters for archbuild.\nDefault is None.")
parser.add_argument('--makechrootpkg_args',
        help="Extra parameters for makechrootpkg.\nAlways have '-U pkgbuild'.\nDefault is ''.")
parser.add_argument('--makepkg_args',
        default='--nocheck',
        help="Extra parameters for makepkg.\nAlways have '--noprogressbar'.\nDefault is '--nocheck'.")
parser.add_argument('--time_limit',
        default=1,
        type=float,
        help="Time limit for archbuild in hours.\nDefault is 1.")

args = parser.parse_args()

commands = [args.build_prefix + '-build']
if args.archbuild_args:
    commands.append(args.archbuild_args)
commands.append('--')
commands.append('-U pkgbuild')
if args.makechrootpkg_args:
    commands.append(args.makechrootpkg_args)
commands.append('--')
commands.append('--noprogressbar')
commands.append(args.makepkg_args)
commands.append('1>"$HOME"/extra-x86_64-build.log 2>&1')

print('cd ${GITHUB_WORKFLOW}')
print(' '.join(commands))
print('ls -l "$HOME"/{packages,sources,srcpackages,makepkglogs}')
