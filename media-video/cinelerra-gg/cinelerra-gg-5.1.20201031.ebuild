# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib

DESCRIPTION="The most advanced non-linear video editor and compositor (goodguy branch)"
HOMEPAGE="https://www.cinelerra-gg.org"
SRC_URI="https://cinelerra-gg.org/download/pkgs/src/cin_${PV}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa cuda dv dvb ieee1394 ladspa lv2 numa openexr opengl oss pulseaudio shuttle static usb v4l2 vaapi vdpau vidmode xft xv"

# TODO: system-pkg use flags
#SYS_DEPS="a52dec djbfft audiofile encore esound ffmpeg fftw flac giflib lame libavc1394 libraw1394 libiec61883 libdv libjpeg opus openjpeg libogg libsndfile libtheora libuuid libvorbis mjpegtools openexr ilmbase tiff twolame x264 x265 libvpx lv2 sratom serd sord lilv suil libaom dav1d libwebp ffnvcodec"
#for d in ${SYS_DEPS}; do
#	IUSE+=" -system-${d}"
#done

# FIXME: opencv support requires opencv with contrib ximgproc module
RDEPEND="
	lv2? ( x11-libs/gtk+:2 )
	opengl? ( virtual/opengl virtual/glu )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	xft? ( x11-libs/libXft )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	vidmode? ( x11-libs/libXxf86vm )
	usb? ( virtual/libusb:1 )
	numa? ( sys-process/numactl )
	xv? ( x11-libs/libXv )
	vdpau? ( x11-libs/libvdpau )
	vaapi? ( x11-libs/libva )
	dev-libs/libisofs"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
	v4l2? ( sys-kernel/linux-headers )
	shuttle? ( x11-base/xorg-proto )"
BDEPEND=""

S="${WORKDIR}/cinelerra-$(ver_cut 1-2 ${PV})"

src_prepare() {
	default
	./autogen.sh
}

src_configure() {
	myconfig=(
		--with-plugindir=/usr/$(get_libdir)/${PN}
		--with-ladspa-dir=/usr/$(get_libdir)/ladspa
		--with-exec-name=cinelerra-gg
		--enable-static-build=$(usex static)
		--with-ladspa=$(usex ladspa)
		--with-lv2=$(usex lv2)
		--with-gl=$(usex opengl)
		--with-cuda=$(usex cuda)
		--with-xft=$(usex xft)
		--with-oss=$(usex oss)
		--with-alsa=$(usex alsa)
		--with-pulse=$(usex pulseaudio)
		--with-firewire=$(usex ieee1394)
		--with-dv=$(usex dv)
		--with-dvb=$(usex dvb)
		--with-video4linux2=$(usex v4l2)
		--with-xxf86vm=$(usex vidmode)
		--with-xv=$(usex xv)
		--with-shuttle=$(usex shuttle)
		--with-shuttle_usb=$(usex usb)
		--with-opencv=no
		--with-vdpau=$(usex vdpau)
		--with-vaapi=$(usex vaapi)
		--with-numa=$(usex numa)
		--with-openexr=$(usex openexr)
		--with-dl
		--with-libzmpeg
		--with-libisofs

		--with-ladspa-build=no
		#--with-noelision
		#--with-booby

		#$(use_disable a52dec)
	)
	econf ${myconfig[@]}
}

src_install() {
	emake -j1 install DESTDIR="${D}"
}
