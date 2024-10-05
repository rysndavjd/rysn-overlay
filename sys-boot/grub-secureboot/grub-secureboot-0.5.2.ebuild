# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HOMEPAGE="https://github.com/rysndavjd/grub-secureboot"
DESCRIPTION="Script for secureboot with grub and shim for x86_64"
SRC_URI="https://github.com/rysndavjd/grub-secureboot/releases/download/${PV}/grub-secureboot-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND="sys-boot/grub
		dev-libs/openssl
		sys-boot/mokutil
		sys-boot/efibootmgr
		app-arch/libarchive[bzip2(+)]
		net-misc/wget
		sys-fs/squashfs-tools
		app-crypt/sbsigntools
		app-shells/bash
		sys-boot/shim
"

src_install() {	
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
