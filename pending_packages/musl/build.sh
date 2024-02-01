#!/bin/sh

. ./config

# if test -f "${OUTPUT_DIR}/lib/libz.a"; then
# 	exit
# fi

## Prepare source
PKG_HOMEPAGE=https://musl.libc.org/
PKG_DESCRIPTION="musl is lightweight, fast, simple, free and strives to be correct in the sense of standards-conformance and safety."
PKG_LICENSE="MIT"

PKG_VERSION="1.2.4"
PKG_BASENAME=musl-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://musl.libc.org/releases/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

./configure \
	--host="${TARGET}" \
	--prefix="${OUTPUT_DIR}" \
	--syslibdir="${OUTPUT_DIR}/lib"

make -j"${JOBS}" install
