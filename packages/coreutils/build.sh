#!/bin/sh

. ./config

# if test -f "${OUTPUT_DIR}/lib/libz.a"; then
# 	exit
# fi

## Prepare source
PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
PKG_LICENSE="GPL-3.0"
PKG_DEPENDS="libandroid-support, libgmp, libiconv"

PKG_VERSION=9.4
PKG_EXTNAME=.tar.xz
PKG_BASENAME=coreutils-${PKG_VERSION}
# PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://${GNU_MIRROR}/gnu.org/gnu/coreutils/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

# export CHOST="${TARGET}"
# ls && exit

patch -up1 <"${WORK_DIR}/packages/coreutils/src-hostid.c.patch"

export FORCE_UNSAFE_CONFIGURE=1

./configure \
	gl_cv_host_operating_system=Android \
	ac_cv_func_getpass=yes \
	--disable-xattr \
	--enable-no-install-program=pinky,users,who \
	--enable-single-binary=symlinks \
	--prefix="${OUTPUT_DIR}" \
	--host="${TARGET}"

make -j"${JOBS}" install
