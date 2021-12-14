# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

MY_PN=XTuner
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Tuner for Jack Audio Connection Kit"
HOMEPAGE="https://github.com/brummer10/${MY_PN}"

#SRC_URI="https://github.com/brummer10/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz"
EGIT_REPO_URI="https://github.com/brummer10/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	virtual/jack
	x11-libs/cairo[X]
	media-libs/liblo
	dev-libs/libsigc++:2
	media-libs/zita-resampler
	sci-libs/fftw:3.0
"
RDEPEND="${DEPEND}"
BDEPEND=""

#S="${WORKDIR}/${MY_P}"

src_configure() {
	:
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}"
}
