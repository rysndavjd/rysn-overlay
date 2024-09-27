# Copyright 2024 rysndavjd
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DWM with my patches included."
HOMEPAGE="https://github.com/rysndavjd/dwm-rysn"
SRC_URI="https://github.com/rysndavjd/dwm-rysn/releases/download/${PV}/dwm-rysn-${PV}.tar.gz"
KEYWORDS=""
RESTRICT="mirror"

CONFIGS="desktop laptop server"
IUSE="${CONFIGS} xinerama"

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="
	^^ ( ${CONFIGS} )
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
	x11-misc/slock-rysn
	x11-apps/xrandr
	x11-apps/xsetroot
	gnome-extra/polkit-gnome
	app-shells/bash
	desktop? (  
			media-sound/pasystray 
	    	gnome-extra/nm-applet
			media-gfx/flameshot 
			net-wireless/blueman 
			media-sound/pavucontrol 
	)
	laptop? ( 
			media-sound/pasystray 
			gnome-extra/nm-applet 
			media-gfx/flameshot 
			net-wireless/blueman 
			x11-misc/cbatticon 
			sys-power/acpilight 
			media-sound/pavucontrol 
	)
"

src_prepare() {
	default

	for num in $CONFIGS ; do
		if use $num ; then
		ln -sr "config-$num.h" "config.h" || die "config-$num.h not found"
		fi
	done

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die "Changing libs failed"
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
}
