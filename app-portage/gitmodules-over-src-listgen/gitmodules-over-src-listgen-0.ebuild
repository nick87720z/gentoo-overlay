# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sources description generator for gitmodules-over-src eclass"
HOMEPAGE="https://github.com/nick87720z/gentoo-overlay"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-vcs/git
	app-shells/bash
	sys-apps/sed
	sys-apps/coreutils
"
BDEPEND=""

src_unpack() {
	:
}

src_prepare() {
	:
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dobin "${FILESDIR}/gitmodules-over-src-listgen"
}

pkg_postinst() {
	elog "Usage:"
	elog "1. Clone repository recursively: git clone --recursive URL PATH"
	elog "2. cd PATH"
	elog "3. Run gitmodules-src-list-gen and validate its output"
	elog "4. Write output to file and move it according to eclass requirements"
}
