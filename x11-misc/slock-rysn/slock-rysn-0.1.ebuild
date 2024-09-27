# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps toolchain-funcs

DESCRIPTION="simple X display locker with my patchs"
HOMEPAGE="https://github.com/rysndavjd/slock-rysn"
SRC_URI="https://github.com/rysndavjd/slock-rysn/releases/download/${PV}/slock-rysn-${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	sys-auth/polkit[daemon]
	gnome-extra/polkit-gnome
	virtual/libcrypt:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
"
DEPEND="
	${RDEPEND}
	!x11-misc/slock
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS/{s: -Os::g; s:= :+= :g}' \
		-e '/^CC/d' \
		-e '/^LDFLAGS/{s:-s::g; s:= :+= :g}' \
		-e "s/ -Os / /" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die
	sed -i \
		-e 's|@${CC}|$(CC)|g' \
		Makefile || die	

	tc-export CC
}

src_compile() {
	emake slock
}

src_install() {
	dobin slock
}

pkg_postinst() {
	# cap_dac_read_search used to be enough for shadow access
	# but now slock wants to write to /proc/self/oom_score_adj
	# and for that it needs:
	fcaps \
		cap_dac_override,cap_setgid,cap_setuid,cap_sys_resource \
		/usr/bin/slock

}
