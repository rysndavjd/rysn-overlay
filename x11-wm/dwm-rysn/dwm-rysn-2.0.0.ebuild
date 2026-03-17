# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DWM with my patches included."
HOMEPAGE="https://github.com/rysndavjd/dwm-rysn"
SRC_URI="https://github.com/rysndavjd/dwm-rysn/releases/download/${PV}/dwm-rysn-${PV}.tar.gz"
KEYWORDS="amd64 arm64"
RESTRICT="mirror"

CONFIGS="desktop"
POLKIT_GUI="polkit-gnome mate-polkit"
IUSE="${CONFIGS} ${POLKIT_GUI} xinerama "

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="
    ^^ ( ${CONFIGS} )
    ^^ ( ${POLKIT_GUI} )
"

RDEPEND="
    media-libs/fontconfig
    x11-libs/libX11
    >=x11-libs/libXft-2.3.5

    polkit-gnome? (
        gnome-extra/polkit-gnome
    )

    mate-polkit? (
        mate-extra/mate-polkit
    )
    
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
    x11-themes/adwaita-icon-theme
    x11-themes/gnome-themes-standard
    x11-misc/rofi
    x11-themes/rysn-wallpapers
    desktop? (  
            media-sound/pasystray 
            gnome-extra/nm-applet
            media-gfx/flameshot 
            net-wireless/blueman 
            media-sound/pavucontrol 
    )
"
DEPEND="
    ${RDEPEND}
    x11-base/xorg-proto
"

src_prepare() {
    default

    sed -i \
        -e "s/ -Os / /" \
        -e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
        -e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
        -e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
        config.mk || die "Changing libs failed"
}

src_compile() {
    for config in $CONFIGS ; do
        if use "$config" ; then
            if use xinerama; then
                emake CC="$(tc-getCC)" CONFIG="$config" dwm
            else
                emake CC="$(tc-getCC)" XINERAMAFLAGS="" XINERAMALIBS="" CONFIG="$config" dwm
            fi
        fi
    done
}

src_install() {
    for config in $CONFIGS ; do
        if use "$config" ; then
            emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" CONFIG="$config" install
        fi
    done
}
