#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libwebsockets.a"; then
	exit
fi

# "${WORK_DIR}"/packages/openssl/build.sh
"${WORK_DIR}"/packages/mbedtls/build.sh
"${WORK_DIR}"/packages/libuv/build.sh

## Prepare source
PKG_HOMEPAGE=https://libwebsockets.org
PKG_DESCRIPTION="Lightweight C websockets library"
PKG_LICENSE="LGPL-2.0"

PKG_VERSION="4.3.3"
PKG_BASENAME=libwebsockets-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/refs/tags/v${PKG_VERSION}${PKG_EXTNAME}

if ! test -d "${BUILD_DIR}/${PKG_BASENAME}"; then
	get_source
fi

cd "${BUILD_DIR}/libwebsockets-${PKG_VERSION}"
sed -i 's/ websockets_shared//g' cmake/libwebsockets-config.cmake.in
# sed -i '/PC_OPENSSL/d' lib/tls/CMakeLists.txt

rm -rf build && mkdir -p build && cd build

export NDK=/media/user/SAMSUNG_64GB/programs/android-ndk-r26b/
# cmake \
# 	-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
# 	-DLWS_WITH_MBEDTLS=1 \
# 	-DLWS_WITHOUT_TESTAPPS=1

if test -f "${OUTPUT_DIR}/lib/libssl.a"; then
	PKG_CMAKE_ARGS="-DLWS_WITH_SSL=ON"
elif test -f "${OUTPUT_DIR}/lib/libmbedtls.a"; then
	PKG_CMAKE_ARGS="-DLWS_WITH_MBEDTLS=ON"
else
	PKG_CMAKE_ARGS="-DLWS_WITH_MBEDTLS=OFF -DLWS_WITH_SSL=OFF"
fi

# shellcheck disable=SC2086
cmake \
	-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
	-DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
	-DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
	-DCMAKE_EXE_LINKER_FLAGS="-static" \
	-DLWS_WITHOUT_TESTAPPS=ON \
	-DLWS_WITH_LIBUV=ON \
	-DLWS_STATIC_PIC=ON \
	-DLWS_WITH_SHARED=OFF \
	-DLWS_UNIX_SOCK=ON \
	-DLWS_IPV6=ON \
	-DLWS_ROLE_RAW_FILE=OFF \
	-DLWS_WITH_HTTP2=OFF \
	-DLWS_WITH_HTTP_BASIC_AUTH=OFF \
	-DLWS_WITH_UDP=OFF \
	-DLWS_WITHOUT_CLIENT=ON \
	-DLWS_WITH_LEJP=OFF \
	-DLWS_WITH_LEJP_CONF=OFF \
	-DLWS_WITH_LWSAC=OFF \
	-DLWS_WITH_SEQUENCER=OFF \
	${PKG_CMAKE_ARGS} \
	..

make -j"${JOBS}" install
