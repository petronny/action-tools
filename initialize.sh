#!/bin/sh
set -ex

find ${GITHUB_WORKSPACE}/action-tools -type f -exec cp {} /usr/bin \;
cp -r ${GITHUB_WORKSPACE}/lilac ~
cp ${GITHUB_WORKSPACE}/lilac/recv_gpg_keys /usr/bin

pacman -Syu --noconfirm
pacman -S --noconfirm --needed base-devel devtools dbus git \
	jq \
	pyalpm python-lxml python-requests python-toposort python-yaml

sed \
	-e "s|MAKEFLAGS=.*|MAKEFLAGS=-j$(nproc)|" \
	-i /etc/makepkg.conf
dbus-uuidgen --ensure=/etc/machine-id
useradd -m pkgbuild -g wheel -d ~
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

pkgbase=$(cat "${GITHUB_EVENT_PATH}" | jq -r .action)
echo "::set-output name=pkgbase::${pkgbase}"
