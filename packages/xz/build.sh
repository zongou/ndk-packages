#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/liblzma.a"; then
	exit
fi

## Prepare source
PKG_VERSION="5.4.5"
PKG_BASENAME="xz-${PKG_VERSION}"
PKG_EXTNAME=.tar.gz
# PKG_SRCURL=https://tukaani.org/xz/${PKG_BASENAME}${PKG_EXTNAME}
PKG_SRCURL=https://github.com/tukaani-project/xz/releases/download/v${PKG_VERSION}/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

## Small build, stripped
export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

export LDFLAGS="-w -s"
./configure \
	--enable-static \
	--disable-shared \
	--prefix="${OUTPUT_DIR}"

make -j"${JOBS}" install
