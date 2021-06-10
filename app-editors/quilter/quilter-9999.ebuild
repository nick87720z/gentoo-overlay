# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#VALA_MAX_API_VERSION=0.34

inherit meson vala xdg-utils gnome2-utils git-r3

DESCRIPTION="Focus on your writing"
HOMEPAGE="https://github.com/lainsce/quilter"
SRC_URI= #"https://github.com/lainsce/${PN}/archive/${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/lainsce/quilter.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/libgee
	gui-libs/libhandy:1
	x11-libs/gtksourceview:4[vala]
	net-libs/webkit-gtk:4
	app-text/gtkspell:3
	app-text/discount
"
DEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default_src_prepare
	vala_src_prepare
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
