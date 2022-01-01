# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A collection of colour schemes for Geany"
HOMEPAGE="https://github.com/geany/geany-themes"
EGIT_REPO_URI="https://github.com/geany/geany-themes"

LICENSE="GPL-3 LGPL-2.1 BSD-2 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-util/geany"

src_compile() {
	echo "Skip compile"
}

src_install() {
	default
	insinto /usr/share/geany
	doins -r colorschemes
}
