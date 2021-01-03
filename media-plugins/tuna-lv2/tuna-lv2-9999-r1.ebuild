# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

X42_HAVE_ROBTK=1
X42_OPT_JACK=1
X42_OPT_INLINE_UI=1
X42_OPT_EXTERN_UI=1

inherit x42-plugin git-r3

DESCRIPTION="A musical instrument tuner with strobe characteristic in LV2 plugin format"
HOMEPAGE="https://x42-plugins.com/x42/x42-tuner"
SRC_URI=""
EGIT_REPO_URI="https://github.com/x42/tuna.lv2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"
