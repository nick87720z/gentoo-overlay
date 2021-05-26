# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Provide a common C++ API for realtime MIDI input/output across ALSA and JACK."
HOMEPAGE="https://github.com/thestk/rtmidi"
SRC_URI="https://github.com/thestk/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Rt-Midi"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa debug +doc jack static examples"

BDEPEND="doc? ( app-doc/doxygen )"
DEPEND="
	jack? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )
	examples? ( sys-apps/dbus )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Until tests and doc compilation are untoggable, we have to build them separately
	sed -ie '/^SUBDIRS\ /d' Makefile.am

	./autogen.sh --no-configure
	default_src_prepare
}

src_configure() {
	myconf=(
		$(use_with jack)
		$(use_with alsa)
		--without-core
		--without-winmm
		--without-winks
		$(use_enable debug)
		$(use_enable static)
		--enable-shared
	)
	econf ${myconf[@]}
}

src_compile() {
	default_src_compile
	use doc && {
		cd doc && emake && cd .. || die "Failed to build doc"
	}
	use examples && {
		cd tests && emake && cd .. || die "Failed to build tests"
	}
}

src_install() {
	default_src_install
	dodoc README.md doc/release.txt
	use doc && {
		dodoc -r doc/html
	}
	use examples && {
		dobin tests/.libs/{cmidiin,midiout,midiprobe,qmidiin,sysextest}
	}
}
