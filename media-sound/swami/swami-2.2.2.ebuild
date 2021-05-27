# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Soundfont editor"
HOMEPAGE="http://www.swamiproject.org https://github.com/swami/swami"
SRC_URI="https://github.com/swami/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="debug fftw fluidsynth"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/gtk+:2
	gnome-base/libgnomecanvas
	media-libs/libinstpatch
	fftw? ( sci-libs/fftw:3.0 )
	fluidsynth? ( media-sound/fluidsynth )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( README.md )

src_prepare() {
	default
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-Denable-fftw=$(usex fftw)
		-Denable-fluidsynth=$(usex fluidsynth)
		-Denable-debug=$(usex debug)
	)
	cmake_src_configure
}
