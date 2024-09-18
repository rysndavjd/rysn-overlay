# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/lbonn/rofi/"
SRC_URI="https://github.com/lbonn/rofi/releases/download/1.7.5%2Bwayland3/rofi-1.7.5+wayland3.tar.gz"
S="${WORKDIR}"/rofi-1.7.5+wayland3
KEYWORDS="amd64 x86"

LICENSE="MIT"
SLOT="0"
IUSE="+drun test +windowmode X +wayland"
RESTRICT="!test? ( test ) mirror"

REQUIRED_USE="
	|| ( X wayland )
"

BDEPEND="
	sys-devel/bison
	>=sys-devel/flex-2.5.39
	virtual/pkgconfig
"
RDEPEND="
	!x11-misc/rofi
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	X? (
		x11-libs/cairo[X,xcb(+)]
		x11-libs/libxcb:=
		x11-libs/libxkbcommon[X]
		x11-libs/pango[X]
		x11-libs/startup-notification
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-wm
		x11-misc/xkeyboard-config
	)
	wayland? (
		x11-libs/libxkbcommon
		x11-libs/pango
		x11-libs/cairo
		>=dev-libs/wayland-protocols-1.17
		dev-libs/wayland
	)
"
DEPEND="
	${RDEPEND}
	X? (
		x11-base/xorg-proto
	)
	
	test? ( >=dev-libs/check-0.11 )
"

src_configure() {
	local emesonargs=(
			-Dcheck=disabled
                        $(meson_use X xcb)
                        $(meson_use wayland)
			$(meson_use drun)
			$(meson_use windowmode window)
			$(meson_feature test check)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
