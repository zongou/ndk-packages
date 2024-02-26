#!/bin/sh

. ./config

"${WORK_DIR}/packages/zlib/build.sh"
"${WORK_DIR}/packages/libwebsocks/build.sh"
"${WORK_DIR}/packages/json-c/build.sh"

## ttyd without ssl ~= 708KB
## ttyd build with mbedtls ~= 1.2 MB
## ttyd build with openssl ~= 5.2MB

## Prepare source
PKG_HOMEPAGE=https://tsl0922.github.io/ttyd/
PKG_DESCRIPTION="Command-line tool for sharing terminal over the web"
PKG_LICENSE="MIT"

# PKG_VERSION="1.7.4"
# PKG_SRCURL=https://github.com/tsl0922/ttyd/archive/refs/tags/${PKG_VERSION}.tar.gz
# 300d8cef4b0b32b0ec30d7bf4d3721a5d180e22607f9467a95ab7b6d9652ca9b sources/ttyd-1.7.4.tar.gz

PKG_VERSION='main'
PKG_BASENAME=ttyd-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/zongou/ttyd/archive/refs/heads/main.tar.gz

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

rm -rf build && mkdir build && cd build
## cannot use -flto with zig to build aarch64 on x86_64
# 	-DCMAKE_C_FLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables" \

cmake \
	-DCMAKE_FIND_ROOT_PATH="${OUTPUT_DIR}" \
	-DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}" \
	-DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
	-DCMAKE_C_FLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables" \
	-DCMAKE_EXE_LINKER_FLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections" \
	-DCMAKE_BUILD_TYPE=RELEASE \
	..

make install
file ttyd
du -ahd0 ttyd
