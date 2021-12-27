# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit git-r3 autotools desktop

DESCRIPTION="Mouse driven MIDI controller."
HOMEPAGE="https://github.com/GModal/raton"
EGIT_REPO_URI="https://github.com/GModal/raton"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""
RESTRICT="mirror"

MY_P="${PN}_v$(ver_cut 1-2 ${PV})_src"
S="${S}/${MY_P}"

DEPEND="
	media-libs/alsa-lib
	x11-libs/gtk+:2
"

PATCHES=(
	"${FILESDIR}/${PN}-arguments.patch"
)

src_prepare() {
	default
	sed -i 's/configure.in/configure.ac/g' configure.in #autogen.sh
	eautoreconf
}

src_install() {
	default
	make_desktop_entry "${PN}" "${PN} mouse to MIDI" "${PN}" "AudioVideo;Audio;Midi"
}
