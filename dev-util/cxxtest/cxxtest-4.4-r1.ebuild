# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="CxxTest is a JUnit/CppUnit/xUnit-like unit testing framework for C++"
HOMEPAGE="http://cxxtest.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples doc"

RDEPEND="
	dev-lang/perl
"

S="${WORKDIR}/${P}/python"

DOCS=( README Versions COPYING )

src_install() {
	use doc && DOCS+=( doc )
	use examples && DOCS+=( sample )
	distutils-r1_src_install

	cd ..
	dobin bin/cxxtestgen
	insinto /usr/include/cxxtest
	doins cxxtest/*
}
