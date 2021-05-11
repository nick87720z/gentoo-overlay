# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils multilib-build multilib-minimal git-r3

DESCRIPTION="Library for serialising LV2 atoms to/from RDF, particularly the Turtle syntax"
HOMEPAGE="https://drobilla.net/software/sratom/"
EGIT_REPO_URI="https://gitlab.com/lv2/sratom.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
	)
"
RDEPEND="
	dev-libs/serd[${MULTILIB_USEDEP}]
	dev-libs/sord[${MULTILIB_USEDEP}]
	media-libs/lv2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	coverage? ( dev-util/lcov )
"
DOCS=( NEWS README.md )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	default
	multilib_copy_sources
}

multilib_src_configure() {
	conf_args=(
		--docdir=/usr/share/doc/${PF}
		$(usex debug       --debug        '')
		$(multilib_native_usex doc --docs '')
		$(usex static-libs --static       '')
		$(usex coverage    ''  --no-coverage)
		$(usex test        --test         '')
	)
	waf-utils_src_configure ${conf_args[@]}
}

multilib_src_test() {
	./waf test || die
}

multilib_src_compile() {
	waf-utils_src_compile
	default
}

multilib_src_install() {
	waf-utils_src_install
	default
}
