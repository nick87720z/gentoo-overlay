# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic bash-completion-r1 git-r3

# zest build mode
BUILD_MODE=release

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer"
HOMEPAGE="https://zynaddsubfx.sourceforge.io/"
EGIT_REPO_URI="https://github.com/zynaddsubfx/zynaddsubfx.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug doc dssi +fltk fusion jack lash ntk oss portaudio sndio test"

REQUIRED_USE="|| ( alsa jack oss portaudio sndio ) ?? ( fltk ntk fusion )"

RDEPEND="
	>=dev-libs/mxml-2.2.1
	media-libs/liblo
	sci-libs/fftw:3.0
	sys-libs/zlib
	media-libs/lv2

	lash?      ( media-sound/lash )
	alsa?      ( media-libs/alsa-lib )
	jack?      ( virtual/jack )
	portaudio? ( media-libs/portaudio )
	sndio?     ( media-sound/sndio )

	fltk?      ( >=x11-libs/fltk-1.3:1 )
	ntk?       ( x11-libs/ntk )
	fusion? (
		dev-libs/libuv
		virtual/opengl
		x11-libs/cairo
	)
"
DEPEND="
	${RDEPEND}
	fusion? (
		sys-devel/libtool
	)
	test? (
		dev-util/cxxtest
		fusion? ( dev-ruby/ruby-prof )
	)
"
BDEPEND="
	fusion? (
		virtual/yacc
		sys-devel/autoconf
		sys-devel/automake
		dev-ruby/rake
	)
	doc? (
		virtual/latex-base
		app-doc/doxygen
		sci-visualization/gnuplot
	)
	virtual/pkgconfig
	app-text/asciidoc
"

DOCS=( AUTHORS.txt NEWS.txt README.adoc README.html )

src_unpack() {
	default
	git-r3_src_unpack

	use fusion && {
		git-r3_fetch "https://github.com/mruby-zest/mruby-zest-build.git"
		git-r3_checkout "https://github.com/mruby-zest/mruby-zest-build.git" "${WORKDIR}/mruby-zest-build"
	}
}

src_prepare() {
	cmake_src_prepare
	filter-flags "-Wl,--as-needed"
}

src_configure() {
	mycmakeargs=(
		-DGuiModule=$(
			{ use ntk && echo "ntk"; } \
			|| { use fltk && echo "fltk"; } \
			|| { use fusion && echo zest; } \
			|| echo "off"
		)
		-DLashEnable=$(usex lash)

		-DAlsaEnable=$(usex alsa)
		-DJackEnable=$(usex jack)
		-DOssEnable=$(usex oss)
		-DPaEnable=$(usex portaudio)
		-DSndioEnable=$(usex sndio)
		-DDefaultOutput=$(
			{ use jack && echo jack; } \
			|| { use alsa && echo alsa; } \
			|| { use portaudio && echo portaudio; } \
			|| { use sndio && echo sndio; } \
			|| { use oss && echo oss; }
		)
		-DDefaultInput=$(
			{ use jack && echo jack; } \
			|| { use alsa && echo alsa; } \
			|| { use sndio && echo sndio; } \
			|| { use oss && echo oss; }
		)
		-DDssiEnable=$(usex dssi)

		-DBUILD_TESTING=$(usex test)
		-DBuildForDebug=$(usex debug)
		-DCompileTests=$(usex test)
		-DPERF_TEST=$(usex test)

		-DPluginLibDir=$(get_libdir)

		-DNoNeonPlease=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	asciidoc -b html README.adoc

	cd "${S}"/ExternalPrograms/Spliter && emake
	cd "${S}"/ExternalPrograms/Controller && emake

	use doc && cmake_src_compile doc

	use fusion && {
		cd "${WORKDIR}/mruby-zest-build"

		ruby rebuild-fcache.rb
		emake clean all
	}
}

src_test() {
	cd "${BUILD_DIR}" && emake test || die
	use fusion && {
		cd "${WORKDIR}/mruby-zest-build"
		emake test
		emake rtest # This is more like for profiling
	}
}

src_install() {
	use doc && DOCS+=( "${BUILD_DIR}/doc/html" )
	cmake_src_install

	rm -r "${D}/usr/share/doc/zynaddsubfx"
	insinto "/usr/share/doc/${PF}/doc"
	doins "doc/zyn-fusion-add.png"

	use fusion && {
		# Copied from linux-pack.sh and install-linux.sh scripts
		cd "${WORKDIR}/mruby-zest-build"
		make pack
		cd package

		insinto "/opt/zyn-fusion"

		doins -r font qml schema VERSION libzest.so
		newins zest zyn-fusion
		fperms a+x "/opt/zyn-fusion/zyn-fusion"
		dosym /opt/zyn-fusion/zyn-fusion /usr/bin/zyn-fusion

		dobashcomp "completions/zyn-fusion"
	}
}
