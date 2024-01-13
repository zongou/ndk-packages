#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libuv.a"; then
	exit
fi

## Prepare source
PKG_HOMEPAGE=https://libuv.org
PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
PKG_LICENSE="MIT, BSD 2-Clause, ISC, BSD 3-Clause"
PKG_LICENSE_FILE="LICENSE"

PKG_VERSION="1.47.0"
PKG_BASENAME=libuv-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
# PKG_SRCURL=https://dist.libuv.org/dist/v${PKG_VERSION}/libuv-v${PKG_VERSION}.tar.gz
PKG_SRCURL=https://github.com/libuv/libuv/archive/refs/tags/v${PKG_VERSION}.tar.gz

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"
./autogen.sh
env CFLAGS=-fPIC ./configure --disable-shared --enable-static --prefix="${OUTPUT_DIR}" --host="${TARGET}"
make -j"${JOBS}" install
