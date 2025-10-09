# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Bash script that verifies your GOG offline installers' authenticity and checksums."
HOMEPAGE="https://github.com/hippie68/gogcheck"
LICENSE="Unknown"
SLOT="0"
RESTRICT="mirror"

IUSE=""
REQUIRED_USE=""
KEYWORDS="amd64"

SRC_URI="https://github.com/hippie68/gogcheck.git"
EGIT_REPO_URI="https://github.com/hippie68/gogcheck.git"


DEPEND="
    app-crypt/osslsigncode
    app-arch/innoextract
"

src_install() {
    dobin gogcheck
    dobin makecertfile
}
