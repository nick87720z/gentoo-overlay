# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Open-source, multichannel, multilayered, cross-platform drum application"
HOMEPAGE="https://www.drumgizmo.org"
SRC_URI="https://www.${PN}.org/releases/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls alsa oss jack jackmidi wav smf lv2 vst static-libs test debug"

# TODO: USE=opengl
# opengl? ( media-libs/pugl )
# --enable-gui=$(usex opengl {pugl-,}x11)

REQUIRED_USE="jackmidi? ( jack )"

RDEPEND="lv2? ( media-libs/lv2 )
		vst? ( media-libs/vst-sdk:2.4 )
		jack? ( virtual/jack )
		wav? ( media-libs/libsndfile )
		alsa? ( media-libs/alsa-lib )
		smf? ( media-libs/libsmf )

		nls? ( sys-devel/gettext )
		x11-libs/libX11
		dev-libs/expat
		media-libs/libpng"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

DOCS="ABOUT AUTHORS BUGS ChangeLog README"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	CONFIG=(
		--enable-gui=x11
		$(use_enable lv2)
		$(use_enable vst)
		$(use_enable alsa     output-alsa)
		$(use_enable oss      output-oss)
		$(use_enable jack     output-jackaudio)
		$(use_enable wav      output-wavfile)
		$(use_enable jackmidi input-jackmidi)
		$(use_enable smf      input-midifile)
		$(use_enable static-libs static)
		$(use_with test)
		$(use_with debug)
		$(use_with nls)
		--with-vst-sources="/usr/include/vst24"
		--disable-sse
	)
	econf ${CONFIG[@]}
}
