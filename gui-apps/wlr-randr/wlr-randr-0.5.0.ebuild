# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Utility to manage outputs of a Wayland compositor."
HOMEPAGE="https://gitlab.freedesktop.org/emersion/wlr-randr"
LICENSE="MIT"
SLOT="0"
RESTRICT="mirror"

IUSE=""
REQUIRED_USE=""
KEYWORDS="amd64 arm64"

SRC_URI="https://gitlab.freedesktop.org/emersion/wlr-randr/-/releases/v${PV}/downloads/${P}.tar.gz"
#S="${WORKDIR}"

RDEPEND="
	dev-libs/wayland
"

BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

DEPEND="
	${RDEPEND}
"

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
    dodoc README.md wlr-randr.1.scd
}
