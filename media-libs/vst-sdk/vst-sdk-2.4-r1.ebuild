# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# install proprietary Steinberg VST SDK 2.4 to "/opt/${MY_P}"
# bug #61290

EAPI="7"
inherit exteutils

RESTRICT="strip fetch"

DESCRIPTION="Steinberg VST Plug-Ins SDK 2.4 - win32"
HOMEPAGE="http://ygrabit.steinberg.de/~ygrabit/public_html"
IUSE="doc"

MY_F='vst_sdk2_4_rev2.zip'
SRC_URI="${MY_F}"

LICENSE="STEINBERG_SOFT-UND_HARDWARE_GMBH"
SLOT="2.4"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND=""

BASE="/opt"
MY_P='vstsdk2.4'
S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	einfo "Please go to ${HOMEPAGE}"
	einfo " or http://www.steinberg.de/532+M52087573ab0.html"
	einfo "- Look for a link called: VST Plug-Ins SDK.."
	einfo "- Download the VST-SDK for version ${PV}"
	einfo "- Extract the archive and put the inner archive ${A}"
	einfo "  into: ${DISTDIR}"
	einfo
	einfo "If above Homepage no longer provide ${A}"
	einfo "You can try to search for ${A} with e.g. google"
	einfo
	einfo "Please redigest your ebuild if you get digest errors:"
	einfo "ebuild ${EBUILD} digest"
	einfo
}

src_unpack() {
	unpack "${MY_F}" || die
#	esed -e :a -e 's/<[^>]*>//g;/</N;//ba' "${S}/VST Licensing Agreement.html" > ${S}/VST_Licensing_Agreement.txt
#	check_license "${S}/VST_Licensing_Agreement.txt"
#	rm -f "${S}/VST_Licensing_Agreement.txt"
#	unneeded_dirs="$(find -type d -name 'CVS')"
#	old_ifs="$IFS"
#IFS="
#"
#	for dir in ${unneeded_dirs[@]};do
#		einfo "delete unneeded dir: $dir"
#		rm -rf "$dir"
#	done
#	IFS="$old_ifs"
	find -type f -exec chmod 0644 {} \;
	find -type d -exec chmod 0755 {} \;
}

src_compile() {
	einfo "nothing to compile :)"
}

include_path="/usr/include/vst24"
src_install() {
	gui_path="vstgui.sf/vstgui"
	header_path="public.sdk/source/vst2.x"
	interface_path="pluginterfaces/vst2.x"

	insinto "${include_path}/${header_path}"
	doins "${header_path}"/*

	insinto "${include_path}/${interface_path}"
	doins "${interface_path}"/*

	rm -r "${header_path}" "${interface_path}"

	dodir "${include_path}/${gui_path}"
	mv "${S}/${gui_path}"/*.{h,cpp} "${D}/${include_path}/${gui_path}"

	if use doc; then
		insinto "${BASE}"
		doins -r "${S}"
		dosym  "${include_path}" "${BASE}/${MY_P}/${header_path}"
	else
		insinto "${BASE}/${MY_P}"
		doins doc/*Licensing\ Agreement*
	fi
	#fowners -R root:root "${BASE}"
}

pkg_postinst() {
	echo
	einfo "Finished installing Steinberg VST Plug-Ins SDK  into"
	einfo "${BASE}/${MY_P} and headers here: ${include_path}"
	einfo "DO NOT IGNORE THE IMPLICATIONS OF THIS LICENSE"
	einfo "${BASE}/${MY_P}/VST Licensing Agreement.html"
	einfo "${BASE}/${MY_P}/VST licensing agreement.rtf"
}
