# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info systemd tmpfiles

# These settings are obtained by running ./build_dist.sh shellvars` in
# the upstream repo.
VERSION_MINOR="76"
VERSION_SHORT="1.76.1"
VERSION_LONG="1.76.1-t24929f6b6"
VERSION_GIT_HASH="24929f6b611127cdc40d45ef40d75c6afc1fcc4c"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/rysndavjd/tailscale-deps/releases/download/${PV}/${P}-deps.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

CONFIG_CHECK="~TUN"

RDEPEND="net-firewall/iptables"
BDEPEND=">=dev-lang/go-1.22"

RESTRICT="test mirror"

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	ego build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}
		-X tailscale.com/version.gitCommitStamp=${VERSION_GIT_HASH}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	dosbin tailscaled
	dobin tailscale

	systemd_dounit cmd/tailscaled/tailscaled.service
	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	#newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "cmd/tailscaled/tailscaled.openrc" ${PN}
	#newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

#pkg_postinst() {
#	tmpfiles_process ${PN}.conf
#}
