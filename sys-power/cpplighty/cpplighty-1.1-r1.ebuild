# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Alternative to python based acpilight for setting backlight brightness"
HOMEPAGE="https://github.com/rysndavjd/cpplighty"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE=""
KEYWORDS="amd64 arm64"

SRC_URI="https://github.com/rysndavjd/cpplighty/releases/download/${PVR}/cpplighty-${PVR}.tar.gz"
S="${WORKDIR}/cpplighty-${PVR}"

RDEPEND="
    virtual/udev
	acct-group/video
"

src_install() {
    emake install DESTDIR=${D}
    udev_dorules "${S}"/50-cpplighty.rules
    newinitd "${S}"/cpplighty.initd cpplighty
    newconfd "${S}"/cpplighty.confd cpplighty
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}