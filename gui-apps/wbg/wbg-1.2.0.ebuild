# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Super simple wallpaper application"
HOMEPAGE="https://codeberg.org/dnkl/wbg"
LICENSE="MIT ZLIB"
SLOT="0"
RESTRICT="mirror"

IUSE="png jpeg webp +svg"
REQUIRED_USE="
|| ( png jpeg webp svg )"

KEYWORDS="amd64 ~arm64"

SRC_URI="https://codeberg.org/dnkl/wbg/archive/${PV}.tar.gz  -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

RDEPEND="
	dev-libs/wayland
	x11-libs/pixman
	jpeg? ( >=media-libs/libjpeg-turbo-2.1.5.1 )
	png? ( >=media-libs/libpng-1.6.41 )
	webp? ( >=media-libs/libwebp-1.3.0 )
"

BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

DEPEND="
	${RDEPEND}
	dev-libs/tllist
"

src_configure() {
	local emesonargs=(
		$(meson_feature png)
		$(meson_feature jpeg)
		$(meson_feature webp)
		$(meson_use svg svg)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc README.md CHANGELOG.md
}