#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libjson-c.a"; then
	exit
fi

## Prepare source
PKG_HOMEPAGE=https://github.com/json-c/json-c/wiki
PKG_DESCRIPTION="A JSON implementation in C"
PKG_LICENSE="MIT"

PKG_VERSION="0.17"
PKG_BASENAME=json-c-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://s3.amazonaws.com/json-c_releases/releases/${PKG_BASENAME}${PKG_EXTNAME}

if ! test -d "${BUILD_DIR}/${PKG_BASENAME}"; then
	get_source
fi

cd "${BUILD_DIR}/${PKG_BASENAME}"
rm -rf build && mkdir build && cd build

cmake \
	-DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
	-DBUILD_SHARED_LIBS=OFF \
	-DBUILD_TESTING=OFF \
	-DDISABLE_THREAD_LOCAL_STORAGE=ON \
	..

make -j"${JOBS}" install
