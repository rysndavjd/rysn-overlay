# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

HOMEPAGE="https://github.com/rysndavjd/1initramfs"
DESCRIPTION="initramfs generation tool for making a highly as compact initramfs using busybox"
SRC_URI="https://github.com/rysndavjd/1initramfs/releases/download/${PV}/1initramfs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

IUSE="gzip zstd lzma bzip2 lz4 cryptsetup ykpers"

RDEPEND="app-shells/bash
		sys-apps/gawk
        sys-apps/sed
        sys-apps/coreutils
        sys-apps/busybox[static]
        app-arch/cpio
        ykpers? (
            sys-auth/ykpers
        )
        cryptsetup? (
            sys-fs/cryptsetup
        )
        gzip? (
            app-arch/gzip
        )
        zstd? (
            app-arch/zstd
        )
        lzma? (
            app-arch/xz-utils
        )
        bzip2? (
            app-arch/bzip2
        )
        lz4? (
            app-arch/lz4
        )
"
pkg_pretend() {
	if ! linux_config_exists; then
		ewarn "Unable to check your kernel."
	else
		CONFIG_CHECK="~DEVTMPFS BLK_DEV_INITRD ~RD_GZIP ~RD_BZIP2 ~RD_LZ4 ~RD_LZMA ~RD_ZSTD"
		ERROR_DEVTMPFS="DEVTMPFS is recommended for ease of populating /dev automatically"
        ERROR_BLK_DEV_INITRD="Initramfs support is kinda needed to use a initramfs"
        ERROR_RD_GZIP="Gzip decompression support needed for loading a gzip compressed initramfs"
        ERROR_RD_BZIP2="Bzip2 decompression support needed for loading a bzip2 compressed initramfs"
        ERROR_RD_LZMA="LZMA decompression support needed for loading a LZMA compressed initramfs"
        ERROR_RD_LZ4="LZ4 decompression support needed for loading a LZ4 compressed initramfs"
        ERROR_RD_ZSTD="ZSTD decompression support needed for loading a ZSTD compressed initramfs"
        check_extra_config
    fi
}

src_install() {	
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
