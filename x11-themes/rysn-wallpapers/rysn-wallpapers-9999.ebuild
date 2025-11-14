# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Random wallpapers from games I like."
HOMEPAGE="https://github.com/rysndavjd/wallpapers"
LICENSE="Unlicense"
SLOT="0"
RESTRICT="mirror"

IUSE=""
REQUIRED_USE=""
KEYWORDS="amd64"

SRC_URI="https://github.com/rysndavjd/wallpapers.git"
EGIT_REPO_URI="https://github.com/rysndavjd/wallpapers.git"

DEPEND="
"

src_install() {
    insinto /usr/share/rysn-wallpapers
    doins *.png
	fperms -R 755 /usr/share/rysn-wallpapers 
}
