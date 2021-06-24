# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gitmodules-over-src.eclass
# @MAINTAINER:
# Nikita Zlobin <nick87720z@gmail.com>
# @AUTHOR:
# Nikita Zlobin <nick87720z@gmail.com>
# @BLURB: Eclass for git submodules fetching via SRC_URI from Git hosting
# @DESCRIPTION:
# This eclass unpacks full source tree from git submodules, downloaded in separate archives from git hosting.

# @ECLASS-VARIABLE: GITMODULES_SRC_URI
# @OUTPUT_VARIABLE
# @DESCRIPTION
# Sources list, generated from gitmodules list variable

# @ECLASS_VARIABLE: GITMODULES_LIST
# @PRE_INHERIT
# @DESCRIPTION
# Each line of this list has following format: RELATIVE-PATH FILE-NAME FILE-EXT SNAPSHOT-URL
# List is expected to be sorted by RELATIVE-PATH field.
# It could be generated from existing repository by runing gitmodules-src-list-gen inside repository.

case ${EAPI:-0} in
* ) ;;
esac

EXPORT_FUNCTIONS src_unpack

GITMODULES_SRC_URI=

while read m_path m_fname m_ext m_url; do
	[ "${m_path}" ] || continue
	GITMODULES_SRC_URI+=" ${m_url} -> ${m_fname}.${m_ext}"
done <<< "${GITMODULES_LIST}"
export GITMODULES_SRC_URI

gitmodules-over-src_src_unpack() {
	default_src_unpack

	# Don't rely to ${S}, as it could be set by ebuild to ${P} subdir
	m_top=$( realpath --relative-base="${WORKDIR}" "${S}" )
	cd "${WORKDIR}/${m_top/\/*/}"

	einfo "Relocating git modules:"
	while read m_path m_fname m_ext m_url; do
		[ "${m_path}" ] || continue
		[ -d "${m_path}" ] || mkdir -p "${m_path}"
		einfo "\t${m_fname} \t-> ${m_path}"
		mv -f "../${m_fname}"/* "${m_path}"/
	done <<< "${GITMODULES_LIST}"
}
