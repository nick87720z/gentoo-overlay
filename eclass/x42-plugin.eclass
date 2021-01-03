# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: x42-plugin.eclass
# @MAINTAINER:
#  Nikita Zlobin <nick88720z@gmail.com>
# @AUTHOR:
#  Nikita Zlobin <nick87720z@gmail.com>
# @BLURB: simplifies writing ebuilds for x42 studio plugins
# @DESCRIPTION:
# This eclass simplifies writing ebuilds for x42 studio plugins.
# Their dependencies and install sequence are so similar, that
# they could be theoretically copy-pasted with ony modifications for essential
# differences, such as name, description and source urls.
#
# USE flags support in robtk-powered x42 plugins
# 
# Name		   b:jack  b:ext   b:inline
# 
# darc         +       +       +
# dpl          +       +       +
# fat1         +       +       -
# fil4         +       +       +
# matrixmixer  +       +       -
# meters       -       -       -
# mixtri       -       +       -
# sisco        -       -       -
# spectra      +       +       -
# stepseq      +       +       -
# tuna         +       +       +

# Basic features

inherit multilib
EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install

LICENSE="GPL-2"
SLOT="0"
IUSE="+optimize"
RDEPEND="media-libs/lv2"

# Ebuild options for robtk-specific features
#
# X42_HAVE_ROBTK=0
#
# Make variable names
#
# X42_OPT_JACK=0
# X42_OPT_INLINE_UI=0
# X42_OPT_EXTERN_UI=0

# Conditional features

ROBTK_DEPS="
	x11-libs/gtk+:2
	virtual/opengl"

if [ "$((X42_HAVE_ROBTK))" -ne 0 ]
then
	if [ "$((X42_OPT_JACK))" -ne 0 ]; then
		IUSE+=" +jack"
		RDEPEND+=" jack? ( virtual/jack ${ROBTK_DEPS} )"
	else
		RDEPEND+=" virtual/jack ${ROBTK_DEPS}"
	fi

	##===##

	if [ "$((X42_OPT_INLINE_UI))" -ne 0 ]; then
		IUSE+=" +inline-ui"
		RDEPEND+=" inline-ui? ( x11-libs/pango x11-libs/cairo )"
	else
		RDEPEND+=" x11-libs/pango x11-libs/cairo"
	fi

	##===##

	if [ "$((X42_OPT_EXTERN_UI))" -ne 0 ]; then
		IUSE+=" +external-ui"
		RDEPEND+=" external-ui? ( ${ROBTK_DEPS} )"
	else
		RDEPEND+=" ${ROBTK_DEPS}"
	fi
fi

DEPEND="${RDEPEND}"
DOCS=( README.md )

# Last place, where ebuild feature conditionals apply

x42-plugin_src_prepare()
{
	default
	if [ $((X42_HAVE_ROBTK)) -ne 0 ]; then
		make submodules
	fi

	export X42_CONFIG+=(
		$( usex optimize "" "OPTIMIZATIONS=" )
		$( [ "$((X42_OPT_JACK))"      -ne 0 ] && usex jack        BUILDJACKAPP={yes,no}  )
		$( [ "$((X42_OPT_EXTERN_UI))" -ne 0 ] && usex external-ui BUILDOPENGL={yes,no}   )
		$( [ "$((X42_OPT_INLINE_UI))" -ne 0 ] && usex inline-ui   INLINEDISPLAY={yes,no} )

		# FIXME: Ardour doesn't properly show plugins with lv2 external ui extension
		EXTERNALUI=no
	)
}

x42-plugin_src_configure() {
	echo "Nothing to configure"
}

x42-plugin_src_compile() {
	emake "${X42_CONFIG[@]}"
}

x42-plugin_src_install() {
	emake "${X42_CONFIG[@]}" DESTDIR="${D}" PREFIX="/usr" LV2DIR="/usr/$(get_libdir)/lv2" install
	dodoc "${DOCS[@]}"
}

