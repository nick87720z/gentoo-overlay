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

# @ECLASS-VARIABLE: GITMODULES_LIST
# @PRE_INHERIT
# @DESCRIPTION
# Each line of this list has following format: RELATIVE-PATH FILE-NAME FILE-EXT SNAPSHOT-URL
# List is expected to be sorted by RELATIVE-PATH field.
# It could be generated from existing repository by runing gitmodules-src-list-gen inside repository.

case ${EAPI:-0} in
* ) ;;
esac

EXPORT_FUNCTIONS src_unpack pkg_pretend

gitmodule_snapshot_info() {
	local commit=$1
	local path=$2
	local url=$3

	url="${url%\/}"
	IFS="/" read host tail <<< "${url/*:\/\//}"

	name="${tail/*\//}"
	name="${name%.git}"
	filename="${name}-${commit}"

	url="${url/git:/https:}"

	case "${host}" in
		repo.or.cz )
			printf "%s" "${filename} tar.gz  ${url}/snapshot/${commit}.tar.gz" ;;
		*github.com )
			printf "%s" "${filename} tar.gz  ${url%.git}/archive/${commit}.tar.gz" ;;
		*gitlab.com )
			printf "%s" "${filename} tar.bz2 ${url}/-/archive/${commit}/${name}-${commit}.tar.bz2" ;;
		git.savannah.* )
			printf "%s" "${filename} tar.gz  ${url/@(${host}\/r\/|${host}\/git\/)/${host}\/cgit\/}/snapshot/${name}-${commit}.tar.gz" ;;
		git.tuxfamily.org )
			printf "%s" "${filename} tar.gz  ${url}/snapshot/${name}-${commit}.tar.gz" ;;
		* )
			printf "%s" "#" ;;
	esac
}

GITMODULES_SRC_URI=
GITMODULES_UNSUPPORTED=

while read commit path url; do
	[ "${commit}" ] || continue

	read name ext url <<< $(gitmodule_snapshot_info "${commit}" "${path}" "${url}")
	[ "${name}" = "#" ] && {
		GITMODULES_UNSUPPORTED+="
			$url"
		continue
	}
	GITMODULES_SRC_URI+=" ${url} -> ${name}.${ext}"
done <<< "${GITMODULES_LIST}"
export GITMODULES_SRC_URI

# @FUNCTION: gitmodules-over-src_check_urls
# @USAGE: gitmodules-over-src_check_urls
# @RETURN: if no unsupported git hosts, the function will silently return 0 (aka shell true). If any urls have unsupported git hosts, function silently returns 1 (aka shell false).
# @DESCRIPTION:
# Print error if some gitmodules have url with unsupported git hosting.

gitmodules-over-src_check_urls() {
	if [ "${GITMODULES_UNSUPPORTED}" ]; then
		eerror "Unsupported git hosts for these URLs:"
		while read l; do
			[ "${l}" ] && eerror "\t${l}"
		done <<< "${GITMODULES_UNSUPPORTED}"
		return 1
	fi
	return 0
}

# @FUNCTION: gitmodules-over-src_pkg_pretend
# @USAGE: gitmodules-over-src_pkg_pretend
# @DESCRIPTION:
# Calls gitmodules-over-src_check_urls, aborting emerge in case of false.

gitmodules-over-src_pkg_pretend() {
	gitmodules-over-src_check_urls || die
}

# @FUNCTION: gitmodules-over-src_src_unpack
# @USAGE: gitmodules-over-src_src_unpack
# @DESCRIPTION:
# Unpacks working tree, unpacking git submodules from source archives.
# See GITMODULES_LIST description.

gitmodules-over-src_src_unpack() {
	default_src_unpack

	# Don't rely to ${S}, as it could be set by ebuild to ${P} subdir
	m_top=$( realpath --relative-base="${WORKDIR}" "${S}" )
	cd "${WORKDIR}/${m_top/\/*/}"

	einfo "Relocating git modules:"
	while read commit path url; do
		[ "${commit}" ] || continue

		read name ext url <<< $(gitmodule_snapshot_info "${commit}" "${path}" "${url}")
		[ "${name}" = "#" ] && continue

		[ -d "${path}" ] || mkdir -p "${path}"
		einfo "\t${name} \t-> ${path}"
		mv -f "../${name}"/* "${path}"/
	done <<< "${GITMODULES_LIST}"
}
