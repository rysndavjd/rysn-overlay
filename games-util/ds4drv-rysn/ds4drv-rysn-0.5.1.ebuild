# Copyright 2024 rysndavjd
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi udev

DESCRIPTION="ds4drv with my patches included."
HOMEPAGE="https://github.com/rysndavjd/ds4drv-rysn"
SRC_URI="https://github.com/rysndavjd/ds4drv-rysn/archive/refs/tags/0.5.1.tar.gz"
KEYWORDS="amd64"
SLOT=0
RESTRICT="mirror"

S=${WORKDIR}/ds4drv-rysn-0.5.1

src_install() {
    insinto /lib/udev/rules.d
    doins udev/50-ds4drv.rules
    insinto /etc
    doins ds4drv.conf
}

pkg_postinst() {
    udev_reload
}

pkg_postrm() {
    udev_reload
}