# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="X11 keyboard indicator and switcher"
HOMEPAGE="https://zen-tools.github.io/gxkb"
SRC_URI="https://github.com/zen-tools/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="appindicator"

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/libwnck:3
	>=x11-libs/libxklavier-4.0
	dev-libs/libappindicator
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

src_prepare() {
	default
	{
		find . -name '*.[ch]'
		echo configure.ac
	} | xargs sed -i 's|ayatana-appindicator|appindicator|'
	./autogen.sh
}

src_configure() {
	myconf=(
		$(use_enable appindicator appindicator)
	)
	econf "${myconf[@]}"
}
