# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit pax-utils

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tgz" # SRC_URI is left blank on live ebuild

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	"

# x11-libs/motif[static-libs] breaks the build. 
# See upstream discussion 
# http://afni.nimh.nih.gov/afni/community/board/read.php?1,85348,85348#msg-85348

DEPEND="
	x11-libs/motif[-static-libs]
	app-shells/tcsh
	dev-libs/expat
	x11-libs/libXpm
	"

S=${WORKDIR}/afni_src
BUILD="linux_fedora_19_64"

src_prepare() {
	sed -e 's/-V 32//g' -i other_builds/Makefile.${BUILD} # they provide somewhat problematic makefiles :(
	cp other_builds/Makefile.${BUILD} Makefile # some Makefile under ptaylor looks
	# for the parent makefile at "Makefile".	
	}

src_compile() {
	emake -j1 totality # suma XLIBS="-lXm -lXt" LGIFTI=-lexpat
	}

src_install() {
	insinto /opt/${PN}
	doins -r "${S}/${BUILD}"/*
	echo "LDPATH=/opt/afni" >> "${T}"/95${PN} || die "Can't write environment variable."
	doenvd "${T}"/95${PN}

	mkdir -p "${D}/usr/bin"
	cp ${S}/${BUILD}/${PN} "${D}/usr/bin/${PN}"
	pax-mark m "${D}/usr/bin/${PN}"
	}