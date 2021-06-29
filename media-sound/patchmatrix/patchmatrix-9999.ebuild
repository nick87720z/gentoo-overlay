# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="JACK patchbay in flow matrix style"
HOMEPAGE="https://git.open-music-kontrollers.ch/lad/patchmatrix/about"
SRC_URI=""
EGIT_REPO_URI="
	https://git.open-music-kontrollers.ch/lad/patchmatrix
	https://gitlab.com/OpenMusicKontrollers/patchmatrix.git
	https://github.com/OpenMusicKontrollers/patchmatrix
"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	virtual/jack
	x11-libs/libX11
	x11-libs/libXext
	media-libs/glew:0
	virtual/glu
	virtual/opengl
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	media-libs/lv2
"
