# Copyright 2021 Nikita Zlobin
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="PlUgin Graphics Library - a minimal portable API for embeddable GUIs"
HOMEPAGE="https://gitlab.com/lv2/pugl.git"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.com/lv2/pugl.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

IUSE="cairo opengl vulkan doc examples test"

COMMON_DEPEND="
	cairo? ( x11-libs/cairo[X] )
	opengl? ( virtual/opengl )
	x11-libs/libX11
"

RDEPEND="${COMMON_DEPEND}
	vulkan? ( media-libs/vulkan-loader[X] )
"

DEPEND="${COMMON_DEPEND}
	doc? (
		app-doc/doxygen
		dev-python/sphinx
	)
	vulkan? ( dev-util/vulkan-headers )
	x11-base/xorg-proto
"

# Can't build out of source
BUILD_DIR="${S}/build"

src_configure() {
	emesonargs=(
		$(meson_feature doc docs)
		$(meson_use examples)
		$(meson_use test tests)
		$(meson_feature cairo)
		$(meson_feature opengl)
		$(meson_feature vulkan)
	)
	meson_src_configure
}
