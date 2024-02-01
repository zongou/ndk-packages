#!/bin/sh

. ./config

## Prepare source
PKG_VERSION="2.1.12"
PKG_BASENAME=libevent-release-${PKG_VERSION}-stable
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/libevent/libevent/archive/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

./autogen.sh
./configure \
	--host=${TARGET} \
	--prefix="${OUTPUT_DIR}"

make -j$(nproc) install

# mkdir -p build
# cd build
# cmake ..
# make
