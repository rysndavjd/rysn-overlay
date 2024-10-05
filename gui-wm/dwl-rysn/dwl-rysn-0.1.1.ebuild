# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

SRC_URI="https://github.com/rysndavjd/${PN}/releases/download/${PV}/${PN}-${PV}.tar.gz"
KEYWORDS=""
DESCRIPTION="dwm for Wayland with my patches included."
HOMEPAGE="https://github.com/rysndavjd/dwl-rysn"
RESTRICT="mirror"

CONFIGS="desktop laptop"
IUSE="${CONFIGS} X"

LICENSE="CC0-1.0 GPL-3+ MIT"
SLOT="0"

REQUIRED_USE="
	^^ ( ${CONFIGS} )
	desktop? ( !laptop )
	laptop? ( !desktop )
"

COMMON_DEPEND="
	=gui-libs/wlroots-0.18.0:=[libinput,session,X?]
	dev-libs/libinput:=
	dev-libs/wayland
	x11-libs/libxkbcommon
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
	)
"

RDEPEND="
	${COMMON_DEPEND}
	app-shells/bash
	gnome-extra/polkit-gnome
	net-wireless/blueman
	media-sound/pavucontrol[X?]
	gui-apps/swaybg[gdk-pixbuf]
	
	laptop? (
		sys-power/acpilight
	)

	X? (
		x11-base/xwayland
	)
"
# uses <linux/input-event-codes.h>
DEPEND="
	${COMMON_DEPEND}
	sys-kernel/linux-headers
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.32
	>=dev-util/wayland-scanner-1.23
	virtual/pkgconfig
"

src_prepare() {
	default
}

src_compile() {
	for num in $CONFIGS ; do
		if use $num ; then
			config="$num"
		fi
	done
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)" CC="$(tc-getCC)" \
		CONFIG="$config" \
		XWAYLAND="$(usev X -DXWAYLAND)" XLIBS="$(usev X "xcb xcb-icccm")" dwl
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc CHANGELOG.md README.md
	elog "Remember the .bash_profile at /usr/share/dwl-rysn/"
}
