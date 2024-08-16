# Copyright 2024 rysndavjd
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secureboot

HOMEPAGE="https://github.com/rysndavjd/grub-secureboot"
DESCRIPTION="Script for secureboot with grub and shim for x86_64"
SRC_URI="https://github.com/rysndavjd/grub-secureboot/releases/download/0.4/grub-secureboot-0.4.tar.gz"
S="${WORKDIR}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

src_install() {
    insinto /usr/sbin/
	doins grub-mkmok.sh
	doins grub-mksecureboot.sh
}
