# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 multilib

DESCRIPTION="MelMatchEQ is a profiling EQ using a 26 step Mel Frequency Band"
HOMEPAGE="https://github.com/brummer10/MelMatchEQ.lv2"
SRC_URI=""

EGIT_REPO_URI="https://github.com/brummer10/MelMatchEQ.lv2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/cairo[X]
	media-libs/lv2
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}" INSTALL_DIR="/usr/$(get_libdir)/lv2"
}
