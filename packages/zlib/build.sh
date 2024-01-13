#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libz.a"; then
	exit
fi

## Prepare source
PKG_HOMEPAGE=https://www.zlib.net/
PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
PKG_LICENSE="ZLIB"

PKG_VERSION="1.3"
PKG_BASENAME=zlib-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://zlib.net/fossils/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

# export CHOST="${TARGET}"
./configure --static --archs="-fPIC" --prefix="${OUTPUT_DIR}"
make -j"${JOBS}" install
