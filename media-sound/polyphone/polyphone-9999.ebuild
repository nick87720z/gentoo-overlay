# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils desktop git-r3

DESCRIPTION="Qt soundfont editor for quickly designing musical instruments."
HOMEPAGE="https://polyphone-soundfonts.com/"
EGIT_REPO_URI="https://github.com/davy7125/polyphone.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="libressl"

RDEPEND="
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	media-libs/alsa-lib
	virtual/jack
	media-libs/portaudio
	media-libs/rtmidi
	media-libs/stk
	dev-libs/qcustomplot
	media-libs/libogg
	media-libs/libvorbis
	media-libs/flac
	libressl? ( dev-libs/libressl )
	!libressl? ( dev-libs/openssl )
"
DEPEND="${RDEPEND}"

S+="/sources"

src_prepare() {
	default
}

src_configure() {
	eqmake5
}

src_install() {
	dobin bin/polyphone
	doicon -s scalable -c apps      contrib/polyphone.svg
	doicon -s scalable -c mimetypes contrib/audio-x-soundfont.svg
	doicon -s 512      -c apps      resources/polyphone.png
	domenu contrib/com.polyphone_soundfonts.polyphone.desktop
	doman contrib/man/man1/polyphone.1
	dodoc ../README.md changelog

	insinto /usr/share/mime/packages
	doins contrib/polyphone.xml
}
