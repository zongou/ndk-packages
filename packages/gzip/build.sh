#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libz.a"; then
	exit
fi

## Prepare source
PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
PKG_DESCRIPTION="Standard GNU file compression utilities"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=1.13
PKG_BASENAME=gzip-${PKG_VERSION}
PKG_EXTNAME=.tar.xz
PKG_SRCURL=${GNU_MIRROR}/gnu/gzip/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

## Small build, stripped
export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

./configure \
	ac_cv_path_GREP=grep \
	--prefix="${OUTPUT_DIR}" \
	--host="${TARGET}"

make -j"${JOBS}" install
