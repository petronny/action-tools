#!/bin/sh
set -ex

find ${GITHUB_WORKSPACE}/action-tools -type f -exec cp {} /usr/bin \;
cp -r ${GITHUB_WORKSPACE}/lilac ~
cp ${GITHUB_WORKSPACE}/lilac/recv_gpg_keys /usr/bin

pacman -Syu --noconfirm
pacman -S --noconfirm --needed base-devel devtools dbus git \
	jq \
	pyalpm python-lxml python-requests python-toposort python-yaml

mkdir -p ~/{packages,sources,srcpackages,makepkglogs}
sed \
	-e "s|MAKEFLAGS=.*|MAKEFLAGS=-j$(nproc)|" \
	-e "s|#PKGDEST=.*|PKGDEST='$HOME/packages'|" \
	-e "s|#SRCDEST=.*|SRCDEST='$HOME/sources'|" \
	-e "s|#SRCPKGDEST=.*|SRCPKGDEST='$HOME/srcpackages'|" \
	-e "s|#LOGDEST=.*|LOGDEST='$HOME/makepkglogs'|" \
	-i /etc/makepkg.conf
dbus-uuidgen --ensure=/etc/machine-id
useradd -m pkgbuild -d ${HOME}
chown -R pkgbuild:root ~

pkgbase=$(cat "${GITHUB_EVENT_PATH}" | jq -r .action)
echo "::set-output name=pkgbase::${pkgbase}"
