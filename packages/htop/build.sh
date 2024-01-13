#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libssl.a"; then
	exit
fi

## Prepare source
PKG_HOMEPAGE=https://www.openssl.org/
PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
PKG_LICENSE="Apache-2.0"

PKG_VERSION="3.3.0"
PKG_BASENAME=htop-${PKG_VERSION}
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://github.com/htop-dev/htop/releases/download/3.3.0/htop-3.3.0.tar.xz

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"
sed -i "s^#define PROCSTATFILE PROCDIR \"/stat\"^#define PROCSTATFILE \"${OUTPUT_DIR}/var/stat\"^" linux/LinuxMachine.h
# patch -up1 <"${WORK_DIR}/packages/htop/access-procstat-file.patch"

ls

export TARGET=aarch64-linux-android33
export CC=${TARGET}-clang
export CXX=${TARGET}-clang++

export CFLAGS="-I${OUTPUT_DIR}/include"
export LDFLAGS="-L${OUTPUT_DIR}/lib"

# ./autogen.sh
# ./configure \
# 	--host="${TARGET}" \
# 	--prefix="${OUTPUT_DIR}" \
# 	--disable-static \
# 	ac_cv_lib_ncursesw6_addnwstr=yes

export LDFLAGS="-L${OUTPUT_DIR}/lib -w -s -static"
export CFLAGS="-I${OUTPUT_DIR}/include -DDPROCSTATFILE=\"${OUTPUT_DIR}/var/stat\""
./configure --host="${TARGET}" --prefix="${OUTPUT_DIR}" --disable-static --enable-unicode LIBS="${OUTPUT_DIR}/lib/libncursesw.a"

make -j"${JOBS}" install
