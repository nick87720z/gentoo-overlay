# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Go-For-It"
VALA_MIN_API_VERSION="0.36"

inherit vala cmake gnome2-utils xdg-utils git-r3

DESCRIPTION="A stylish to-do list with built-in productivity timer"
HOMEPAGE="https://jmoerman.github.io/go-for-it/"
#SRC_URI="https://github.com/mank319/${MY_PN}/archive/release_v${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/JMoerman/${MY_PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="granite plugins test"

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/libnotify
	granite? ( dev-libs/granite )
	plugins? ( dev-libs/libappindicator )"
DEPEND="${RDEPEND}
	${vala_depend}
	virtual/pkgconfig"

DOCS=( AUTHORS CHANGELOG.md README.md screenshot.png )

src_prepare() {
	vala_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PLUGINS=$(usex plugins)
		-DUSE_GRANITE=$(usex granite)
		-DBUILD_TESTS=$(usex test)

		-DVALA_EXECUTABLE="${VALAC}"
		-DGSETTINGS_COMPILE=OFF
		-DGSETTINGS_LOCALINSTALL=OFF
		-DICON_UPDATE=OFF
		-DENABLE_PLUGINS=ON
		-DGLOBAL_PLUGIN_ICONS=ON
		-DAPP_ID=${PN}
		-DAPP_SYSTEM_NAME=${PN}
	)
	cmake_src_configure
}

src_test() {
	tests/com.github.jmoerman.go-for-it-tests || die
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}
