# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='threads(+)'
inherit python-any-r1 waf-utils multilib-build multilib-minimal git-r3

DESCRIPTION="Library for RDF syntax which supports reading and writing Turtle and NTriples"
HOMEPAGE="https://drobilla.net/software/serd/"
EGIT_REPO_URI="https://gitlab.com/drobilla/serd.git https://git.drobilla.net/serd.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc sanity-check static static-libs test +utils"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
	)
"
RDEPEND=""
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	coverage? ( dev-util/lcov )
"
DOCS=( "AUTHORS" "NEWS" "README.md" )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	default
	multilib_copy_sources
}

multilib_src_configure() {
	conf_args=(
		--docdir=/usr/share/doc/${PF}
		$(multilib_native_usex doc --docs            '')
		$(usex test         --test                   '')
		$(usex static-libs  --static                 '')
		$(usex static       --static-progs           '')
		$(usex debug        --debug                  '')
		$(usex utils        ''               --no-utils)
		$(usex sanity-check --stack-check            '')
		$(usex coverage     ''            --no-coverage)
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
