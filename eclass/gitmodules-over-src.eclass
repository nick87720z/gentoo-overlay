# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gitmodules-over-src.eclass
# @MAINTAINER:
# Nikita Zlobin <nick87720z@gmail.com>
# @AUTHOR:
# Nikita Zlobin <nick87720z@gmail.com>
# @BLURB: Eclass for git submodules fetching via SRC_URI from GitHub hosting
# @DESCRIPTION:
# This eclass unpacks full source tree from git submodules, downloaded in separate archives from GitHub.
# Submodules list is defined in external file ${P}-submodules, located in ${FILESDIR} .
# Each list of this list has following format: RELATIVE-PATH FILE-NAME FILE-EXT SNAPSHOT-URL
# List is expected to be sorted by RELATIVE-PATH field.
# It could be generated from existing repository by runing gitmodules-src-list-gen inside repository.

# @ECLASS-VARIABLE: SRC_URI
# @REQUIRED
# @PRE_INHERIT

case ${EAPI:-0} in
* ) ;;
esac

[ -n "${SRC_URI}" ] || die "SRC_URI must be set before inheriting this class"

EXPORT_FUNCTIONS src_unpack

SUBMODULES_FILE="${FILESDIR}/${P}-submodules"

# TODO: generic source tree assembler, not bound to github-specific layout

while read m_path m_fname m_ext m_url; do
	SRC_URI+=" ${m_url} -> ${m_fname}.${m_ext}"
done < "${SUBMODULES_FILE}"

gitmodules-over-src_src_unpack() {
	default_src_unpack

	# S could be set by ebuild to ${P} subdir
	m_top=$( realpath --relative-base="${WORKDIR}" "${S}" )
	cd "${WORKDIR}/${m_top/\/*/}"

	while read m_path m_fname m_ext m_url; do
		[ -d "${m_path}" ] || mkdir "${m_path}"
		mv -f "../${m_fname}"/* "${m_path}"/
	done < "${SUBMODULES_FILE}"
}
