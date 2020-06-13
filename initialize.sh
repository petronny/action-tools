#!/bin/sh
set -ex

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

git config --global user.email "calil@jingbei.li"
git config --global user.name "calil"

echo ${GITHUB_RUN_ID} > ~/workflow_id

pkgbase=$(jq -r .action "${GITHUB_EVENT_PATH}")
uuid=$(echo $pkgbase | cut -d' ' -f2)
pkgbase=$(echo $pkgbase | cut -d' ' -f1)

echo "::add-path::${GITHUB_WORKSPACE}/action-tools"
echo "::set-output name=pkgbase::${pkgbase}"
echo "::set-output name=uuid::${uuid}"
echo "::set-output name=home::${HOME}"
