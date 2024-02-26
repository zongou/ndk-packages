#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libmbedtls.a"; then
	exit
fi

## Prepare source
PKG_VERSION="3.5.2"
PKG_BASENAME=mbedtls-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL="https://github.com/Mbed-TLS/mbedtls/archive/v${PKG_VERSION}.tar.gz"

if ! test -d "${BUILD_DIR}/${PKG_BASENAME}"; then
	get_source
fi

cd "${BUILD_DIR}/${PKG_BASENAME}"
sed -i 's^info->MBEDTLS_PRIVATE(key_bitlen) << MBEDTLS_KEY_BITLEN_SHIFT^(size_t)(info->MBEDTLS_PRIVATE(key_bitlen) << MBEDTLS_KEY_BITLEN_SHIFT)^' include/mbedtls/cipher.h

rm -rf build && mkdir -p build && cd build

cmake \
	-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
	-DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
	-DENABLE_TESTING=OFF \
	-DENABLE_PROGRAMS=OFF \
	..

make -j"${JOBS}" install
