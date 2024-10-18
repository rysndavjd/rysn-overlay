# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#inherit 

DESCRIPTION="Free archive manager for Linux"
HOMEPAGE="https://peazip.github.io/"
LICENSE="LGPL-3"
SLOT="0"
RESTRICT="mirror"

IUSE="qt5 gtk2"
REQUIRED_USE="^^ ( qt5 gtk2 )"
KEYWORDS="amd64"

SRC_URI="https://github.com/peazip/PeaZip/releases/download/9.9.1/peazip_9.9.1.LINUX.Qt5-1_amd64.deb https://github.com/peazip/PeaZip/releases/download/9.9.1/peazip_9.9.1.LINUX.GTK2-1_amd64.deb"
S="${WORKDIR}"/

RDEPEND="
"
DEPEND="
"

src_unpack() {
	if use qt5 ; then
		bsdtar xf "${DISTDIR}"/peazip_9.9.1.LINUX.Qt5-1_amd64.deb
		bsdtar xf "${WORKDIR}"/data.tar.xz --exclude='./usr/bin/peazip' --exclude='./usr/lib/peazip/res/share'
	elif use gtk2 ; then
		bsdtar xf "${DISTDIR}"/peazip_9.9.1.LINUX.GTK2-1_amd64.deb
		bsdtar xf "${WORKDIR}"/data.tar.xz --exclude='./usr/bin/peazip' --exclude='./usr/lib/peazip/res/share'
	fi
}

src_install() {
	insinto /usr/lib/
	doins -r usr/lib/peazip
	fperms -R 755 /usr/lib/peazip 
	insinto /usr
	doins -r usr/share
	dosym /usr/share /usr/lib/peazip/res/share
	dosym /usr/lib/peazip/bin/peazip /usr/bin/peazip
}
