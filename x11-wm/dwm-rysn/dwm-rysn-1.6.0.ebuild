# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DWM with my patches included."
HOMEPAGE="https://github.com/rysndavjd/dwm-rysn"
SRC_URI="https://github.com/rysndavjd/dwm-rysn/releases/download/${PV}/dwm-rysn-${PV}.tar.gz"
KEYWORDS="amd64 arm64"
RESTRICT="mirror"

CONFIGS="desktop laptop server mac"
IUSE="${CONFIGS} xinerama"

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="
    ^^ ( ${CONFIGS} )
    desktop? ( !laptop )
    desktop? ( !server )
    desktop? ( !mac )
    laptop? ( !desktop )
    laptop? ( !server )
    laptop? ( !mac )
    server? ( !desktop )
    server? ( !laptop )
    server? ( !mac )
    mac? ( !desktop )
    mac? ( !laptop )
    mac? ( !server )
"

RDEPEND="
    media-libs/fontconfig
    x11-libs/libX11
    >=x11-libs/libXft-2.3.5
    gnome-extra/polkit-gnome
    x11-apps/xsetroot
    x11-misc/slock-rysn
    x11-apps/xrandr
    app-shells/bash
    media-gfx/feh[xinerama?]
    media-video/pipewire[pipewire-alsa,sound-server,jack-sdk,dbus]
    sys-apps/dbus
    x11-misc/wmname
    x11-apps/xset
    x11-apps/xrdb
    x11-misc/xsettingsd
    media-fonts/cantarell[X]
    media-fonts/symbols-nerd-font[X]
    x11-themes/papirus-icon-theme
    x11-misc/rofi
    x11-themes/gnome-themes-standard
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
            sys-power/cpplighty 
            media-sound/pavucontrol 
    )
    mac? (
            media-sound/pasystray 
            gnome-extra/nm-applet 
            net-wireless/blueman 
            x11-misc/cbatticon 
            sys-power/cpplighty 
            media-sound/pavucontrol 
    )
"
DEPEND="
    ${RDEPEND}
    x11-base/xorg-proto
"

src_prepare() {
    default

    for num in $CONFIGS ; do
        if use $num ; then
            ln -sr "config-$num.h" "config.h" || die "config-$num.h not found"
            sed -i 's/^CONFIG=.*/CONFIG='$num'/' config.mk
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
