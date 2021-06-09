# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils bash-completion-r1 multilib-build multilib-minimal git-r3

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="https://drobilla.net/software/lilv/"
EGIT_REPO_URI="https://gitlab.com/lv2/lilv.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="+bash-completion coverage debug doc +dyn-manifest python static static-libs test +utils"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
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
	python? ( ${PYTHON_DEPS} )
	dev-libs/serd[${MULTILIB_USEDEP}]
	dev-libs/sord[${MULTILIB_USEDEP}]
	media-libs/sratom[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	media-libs/lv2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	coverage? ( dev-util/lcov )
"
DOCS=( AUTHORS NEWS README.md )

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	multilib_copy_sources
}

multilib_src_configure() {
	conf_args=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--pythondir="${PYTHON_SITEDIR}"
		--python="${PYTHON}"
		--no-bash-completion

		$(usex doc             --docs               '')
		$(usex test            --test               '')
		$(usex static          --static-progs       '')
		$(usex static-libs     --static             '')
		$(usex dyn-manifest    --dyn-manifest       '')
		$(usex python          ''        --no-bindings)
		$(usex utils           ''           --no-utils)

		$(usex debug           --debug              '')
		$(usex coverage        ''        --no-coverage)
	)
	waf-utils_src_configure ${conf_args[@]}
}

multilib_src_test() {
	./waf test || die
}

multilib_src_compile() {
	./waf build || die
}

multilib_src_install() {
	waf-utils_src_install
}

multilib_src_install_all() {
	if use bash-completion; then
		sed -i "/lv2jack/d" utils/lilv.bash_completion
		newbashcomp utils/lilv.bash_completion lv2info
	fi

	dodir /etc/env.d
	echo "LV2_PATH=${EPREFIX}/usr/$(get_libdir)/lv2" > "${ED}/etc/env.d/60lv2"

	python_optimize
}
