# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for processing digital sample based MIDI instrument patch files."
HOMEPAGE="http://www.swamiproject.org https://github.com/swami/libinstpatch"
SRC_URI="https://github.com/swami/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/glib
	media-libs/libsndfile
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/astyle
	sys-apps/sed
"
DOCS=( README.md AUTHORS )

src_prepare() {
	default
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DINTROSPECTION_ENABLED=no
		-DGTKDOC_ENABLED=no
	)
	cmake_src_configure
}
