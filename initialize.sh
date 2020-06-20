#!/bin/sh
set -ex

pacman -Syu --noconfirm
pacman -S --noconfirm --needed base-devel devtools dbus git \
	jq zsh\
	pyalpm python-lxml python-requests python-toposort python-yaml

sed \
	-e "s|MAKEFLAGS=.*|MAKEFLAGS=-j$(nproc)|" \
	-i /etc/makepkg.conf
dbus-uuidgen --ensure=/etc/machine-id
useradd -m pkgbuild -g wheel -d ~
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo ${GITHUB_RUN_ID} > ~/workflow_id

pkgbase=$(jq -r .action "${GITHUB_EVENT_PATH}")
uuid=$(echo $pkgbase | cut -d' ' -f2)
pkgbase=$(echo $pkgbase | cut -d' ' -f1)

echo "::add-path::${GITHUB_WORKSPACE}/action-tools"
echo "::add-path::${GITHUB_WORKSPACE}/lilac"
echo "::set-output name=pkgbase::${pkgbase}"
echo "::set-output name=uuid::${uuid}"
echo "::set-output name=home::${HOME}"
