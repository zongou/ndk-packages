#!/bin/sh
set -eu

. ./config

## Prepare source
PKG_HOMEPAGE=https://cmake.org/
PKG_DESCRIPTION="Family of tools designed to build, test and package software"
PKG_LICENSE="BSD 3-Clause"

PKG_VERSION="3.28.1"
PKG_BASENAME=cmake-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL="https://github.com/Kitware/CMake/releases/download/v${PKG_VERSION}/cmake-${PKG_VERSION}.tar.gz"
# PKG_SRCURL="https://mirrors.kernel.org/gnu/make/make-${PKG_VERSION}.tar.gz"
# dep-pkg: libarchive libcurl libuv jsoncpp expat rhash zlib ncurses openssl

if ! test -d "${BUILD_DIR}/${PKG_BASENAME}"; then
	get_source
fi

cd "${BUILD_DIR}/${PKG_BASENAME}"
rm -rf build && mkdir -p build && cd build

cmake \
	-DBUILD_QtDialog=OFF \
	-DBUILD_CursesDialog=ON \
	-DCMake_BUILD_LTO=ON \
	-DCMAKE_USE_OPENSSL=ON \
	-DCMAKE_USE_SYSTEM_CURL=ON \
	-DCMAKE_USE_SYSTEM_EXPAT=ON \
	-DCMAKE_USE_SYSTEM_FORM=ON \
	-DCMAKE_USE_SYSTEM_JSONCPP=ON \
	-DCMAKE_USE_SYSTEM_LIBARCHIVE=ON \
	-DCMAKE_USE_SYSTEM_LIBRHASH=ON \
	-DCMAKE_USE_SYSTEM_LIBUV=ON \
	-DCMAKE_USE_SYSTEM_ZLIB=ON \
	..
