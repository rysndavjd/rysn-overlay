# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION=""
HOMEPAGE=""
LICENSE="GPL-2"
LICENSE+=" MIT Unicode-3.0"
SLOT="0"
RESTRICT="mirror"

IUSE=""
REQUIRED_USE=""
KEYWORDS="amd64 arm64"

CRATES="
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	clap@4.5.34
	clap_builder@4.5.34
	clap_derive@4.5.32
	clap_lex@0.7.4
	colorchoice@1.0.3
	heck@0.5.0
	is_terminal_polyfill@1.70.1
	once_cell@1.21.2
	proc-macro2@1.0.94
	quote@1.0.40
	strsim@0.11.1
	syn@2.0.100
	unicode-ident@1.0.18
	utf8parse@0.2.2
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/rysndavjd/${PN}/releases/download/${PV}/${P}.tar.gz
"

RDEPEND="
    virtual/udev
	acct-group/video
"

src_unpack() {
	cargo_src_unpack
}


src_compile() {
	cargo_src_compile
}


src_install() {
	cargo_src_install
}
