# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Little app to select lv2 plugins for run with jalv"
HOMEPAGE="https://github.com/brummer10/jalv_select"
SRC_URI=""

EGIT_REPO_URI="https://github.com/brummer10/jalv_select"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""

DEPEND="
	media-libs/lilv
	dev-cpp/gtkmm:3.0[X]
	sys-devel/gettext
"
RDEPEND="
	${DEPEND}
	media-sound/jalv
"
BDEPEND=""

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="/usr"
}
