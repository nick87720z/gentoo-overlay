# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils multilib-build multilib-minimal git-r3

DESCRIPTION="lightweight C library for storing RDF data in memory"
HOMEPAGE="https://drobilla.net/software/sord"
EGIT_REPO_URI="https://gitlab.com/drobilla/sord.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc static static-libs test +utils"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
# libpcre is automagic dependency
RDEPEND="
	dev-libs/libpcre[${MULTILIB_USEDEP}]
	dev-libs/serd[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	coverage? ( dev-util/lcov )
"
DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	default
	multilib_copy_sources
}

multilib_src_configure() {
	conf_args=(
		--docdir=/usr/share/doc/${PF}
		$(usex test        --test '')
		$(multilib_native_usex doc --docs         '')
		$(usex static-libs --static               '')
		$(usex static      --static-progs         '')
		$(usex coverage    ''          --no-coverage)
		$(usex debug       '--debug --dump=all'   '')
		$(usex utils       ''             --no-utils)
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
