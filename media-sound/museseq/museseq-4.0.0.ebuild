# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Limited by dev-python/pyro's supported range
PYTHON_COMPAT=( python3_{7..8} )

inherit cmake toolchain-funcs python-single-r1

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="https://muse-sequencer.github.io"
SRC_URI="https://github.com/muse-sequencer/muse/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dssi fluidsynth gtk lash libinstpatch lv2 lrdf osc python rtaudio rubberband static-modules vst vst-sdk"

# NOTE: DSSI automagically enables ALSA and OSC
REQUIRED_USE="dssi? ( alsa osc ) gtk? ( lv2 ) vst-sdk? ( vst ) python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	dev-qt/qtsvg:5
	>=media-libs/libsndfile-1.0
	media-libs/libsamplerate
	virtual/jack
	alsa? (
		>=media-libs/alsa-lib-0.9
	)
	rtaudio? (
		>=media-libs/rtaudio-5.0
	)
	lrdf? (
		media-libs/liblrdf
	)
	dssi? (
		media-libs/dssi
	)
	lv2? (
		gtk? ( x11-libs/gtk+:2 dev-cpp/gtkmm:2.4 )
		>=media-libs/lilv-0.22
		>=media-libs/lv2-1.12
		>=dev-libs/sord-0.14
	)
	lash? (
		|| ( virtual/liblash media-sound/lash )
	)
	osc? (
		media-libs/liblo
	)
	fluidsynth? (
		>=media-sound/fluidsynth-1.0.3
	)
	libinstpatch? (
		>=media-libs/libinstpatch-1.0
	)
	rubberband? (
		media-libs/rubberband
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pyro[${PYTHON_USEDEP}]
			dev-python/PyQt5[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/designer:5
	dev-qt/linguist-tools:5
	media-libs/ladspa-sdk
	vst? (
		vst-sdk? ( media-libs/vst-sdk )
	)
"

S="${WORKDIR}/muse-${PV}/src"
DOCS=( AUTHORS README README.ladspaguis README.softsynth )

src_prepare() {
	default
	cmake_src_prepare
	eapply -p2 "${FILESDIR}"/${PN}-{3.0.2-cmake-rpath,4.0.0-fix-noosc-build,4.0.0-fix-vst-sdk-build}.patch
}

src_configure() {
	mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_DSSI=$(usex dssi)
		-DENABLE_FLUID=$(usex fluidsynth)
		-DENABLE_INSTPATCH=$(usex libinstpatch)
		-DENABLE_LASH=$(usex lash)
		-DENABLE_LRDF=$(usex lrdf)
		-DENABLE_LV2=$(usex lv2)
		-DENABLE_LV2_DEBUG=OFF
		-DENABLE_LV2_GTK2=$(usex gtk)
		-DENABLE_MIDNAM=ON
		-DENABLE_OSC=$(usex osc)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_RTAUDIO=$(usex rtaudio)
		-DENABLE_RUBBERBAND=$(usex rubberband)
		-DENABLE_VST_NATIVE=$(usex vst)
		-DENABLE_VST_VESTIGE=$(usex vst-sdk no yes)
		-DMODULES_BUILD_STATIC=$(usex static-modules)
		-DUPDATE_TRANSLATIONS=OFF
		$(use vst-sdk && echo -DVST_HEADER_PATH="/usr/include/vst24/pluginterfaces/vst2.x")
	)
	cmake_src_configure
}
