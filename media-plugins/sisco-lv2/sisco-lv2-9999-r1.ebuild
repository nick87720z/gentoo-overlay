# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

X42_HAVE_ROBTK=1
X42_CONFIG=( BUILDOPENGL=yes BUILDGTK=no )

inherit x42-plugin git-r3

DESCRIPTION="Simple LV2 audio oscilloscope"
HOMEPAGE="https://x42-plugins.com/x42/x42-scope"
SRC_URI=""
EGIT_REPO_URI="https://github.com/x42/sisco.lv2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
