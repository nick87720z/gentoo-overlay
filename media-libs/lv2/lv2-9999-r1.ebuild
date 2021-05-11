# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE='threads(+),xml(+)'

inherit python-single-r1 waf-utils multilib-build multilib-minimal git-r3

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
EGIT_REPO_URI="https://gitlab.com/lv2/lv2.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc debug plugins coverage test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	plugins? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen dev-python/rdflib app-text/asciidoc )
"
CDEPEND="
	${PYTHON_DEPS}
	plugins? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] media-libs/libsndfile[${MULTILIB_USEDEP}] )
	coverage? ( dev-util/lcov )
"
DEPEND="
	${CDEPEND}
	doc? ( dev-python/markdown )
"
RDEPEND="
	${CDEPEND}
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/pygments[${PYTHON_MULTI_USEDEP}]
		dev-python/rdflib[${PYTHON_MULTI_USEDEP}]
	')
	!<media-libs/slv2-0.4.2
	!media-libs/lv2core
	!media-libs/lv2-ui
"
# no NEWS file in the git version
DOCS=( "README.md" )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	conf_args=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--lv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2
		--copy-headers
		$(use debug    || echo --debug)
		$(multilib_native_usex doc --docs "")
		$(use plugins  || echo " --no-plugins")
		$(use test     && echo --test)
		$(use coverage || echo --no-coverage)
	)
	waf-utils_src_configure ${conf_args[@]}
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install
	multilib_is_native_abi && use doc && dodoc build/plugins/book.{txt,html}
}

multilib_src_install_all() {
	python_fix_shebang "${D}"
}

multilib_src_test() {
	./waf test || die
}
