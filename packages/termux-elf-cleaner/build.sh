#!/bin/sh

. ./config

PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
PKG_DESCRIPTION="Cleaner of ELF files for Android"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=2.2.1
PKG_BASENAME=termux-elf-cleaner-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${PKG_VERSION}${PKG_EXTNAME}

get_source

cd "${BUILD_DIR}/${PKG_BASENAME}"
cp "${WORK_DIR}/packages/termux-elf-cleaner/android-api-level.diff" .

autoreconf -vfi
sed "s%@ANDROID_TARGET_API@%${ANDROID_TARGET_API}%g" android-api-level.diff | patch --silent -p1

./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}"
make -j"${JOBS}" install