# Copyright 2024 rysndavjd
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DWM with my patches included."
HOMEPAGE="https://github.com/rysndavjd/dwm-rysn"
SRC_URI="https://github.com/rysndavjd/dwm-rysn/releases/download/${PV}/dwm-rysn-${PV}.tar.gz"
KEYWORDS="amd64"
RESTRICT="mirror"

IUSE="desktop laptop server xinerama"

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="
	desktop? ( !laptop )
	desktop? ( !server )
	laptop? ( !desktop )
	laptop? ( !server )
	server? ( !desktop )
	server? ( !laptop )
"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	>=x11-libs/libXft-2.3.5
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-misc/slock
	x11-apps/xrandr
	x11-apps/xsetroot
	gnome-extra/polkit-gnome
	app-shells/bash
	desktop? ( media-sound/pasystray )
	desktop? ( gnome-extra/nm-applet )
	desktop? ( media-gfx/flameshot )
	desktop? ( net-wireless/blueman )
	desktop? ( media-sound/pavucontrol )
	laptop? ( media-sound/pasystray )
	laptop? ( gnome-extra/nm-applet )
	laptop? ( media-gfx/flameshot )
	laptop? ( net-wireless/blueman )
	laptop? ( x11-misc/cbatticon )
	laptop? ( x11-apps/xbacklight )
	laptop? ( media-sound/pavucontrol )
"

src_prepare() {
	default

	if use desktop ; then
		ln -sr "config-desktop.h" "config.h" || die "config-desktop.h not found"
	fi
	
	if use laptop ; then
	ln -sr "config-laptop.h" "config.h" || die "config-laptop.h not found"
	fi
	
	if use server ; then
	ln -sr "config-server.h" "config.h" || die "config-server.h not found"
	fi

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die
}

src_compile() {
	if use xinerama; then
		emake CC="$(tc-getCC)" dwm
	else
		emake CC="$(tc-getCC)" XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	dodoc README

	save_config config.h
}
