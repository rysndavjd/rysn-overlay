# Copyright 2024 rysndavjd
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A split package containing OpenRC init scripts for 'pipewire', 'pipewire-pulse' and 'wireplumber'."
HOMEPAGE="https://aur.archlinux.org/pkgbase/pipewire-openrc"
SRC_URI="https://github.com/rysndavjd/pipewire-openrc/releases/download/1.0/pipewire-openrc-1.0.tar"
S="${WORKDIR}/${PN}"
KEYWORDS="amd64"
RESTRICT="mirror"

IUSE="pulseaudio"

LICENSE="GPL-2"
SLOT="0"

REQUIRED_USE="
"

RDEPEND="
	sys-apps/openrc
"
DEPEND="

"

src_install() {
	insinto /etc/init.d
	doins pipewire-openrc wireplumber-openrc
	if use pulseaudio ; then
		doins pipewire-pulse-openrc
	fi
	insinto /etc/conf.d
	doins pipewire-conf.d wireplumber-conf.d
	if use pulseaudio ; then
		doins pipewire-pulse-conf.d
	fi
	elog "Enable service via, rc-update add pipewire-openrc default"
	elog "Enable service via, rc-update add wireplumber-openrc default"
	if use pulseaudio ; then
		elog "Enable service via, rc-update add pipewire-pulse-openrc default"
	fi
}
