# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

X42_HAVE_ROBTK=1

inherit x42-plugin git-r3

DESCRIPTION="A colletion of audio level meters with GUI in LV2 plugin format"
HOMEPAGE="https://x42-plugins.com/x42/x42-meters"
SRC_URI=""
EGIT_REPO_URI="https://github.com/x42/meters.lv2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

DOCS+=( AUTHORS )
