#!/bin/sh

. ./config

if test -f "${OUTPUT_DIR}/lib/libssl.a"; then
	exit
fi

## Prepare source
PKG_HOMEPAGE=https://www.openssl.org/
PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
PKG_LICENSE="Apache-2.0"

PKG_VERSION="3.2.0"
PKG_BASENAME=openssl-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://www.openssl.org/source/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

case "${TARGET}" in
arm*) openssl_target="android-arm" ;;
aarch64*) openssl_target="android-arm64" ;;
i686*) openssl_target="android-x86" ;;
x86_64*) openssl_target="android-x86_64" ;;
esac

# export CFLAGS="-DNO_SYSLOG"

## Android target toolchain
# export ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT:-/media/user/SAMSUNG_64GB/programs/android-ndk-r26b}"
# export PATH="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH}"

## Small build, stripped
# export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

# export PATH="${TOOLCHAIN_DIR}:${PATH}"

export TOOLCHAIN_DIR="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin"
export PATH="${TOOLCHAIN_DIR}:$PATH"

./Configure \
	"${openssl_target}" \
	-D__ANDROID_API__="${ANDROID_TARGET_API}" \
	-static \
	no-asm \
	no-shared \
	no-tests \
	--prefix="${OUTPUT_DIR}"

# ./Configure "${openssl_target}" \
# 	shared \
# 	zlib-dynamic \
# 	no-ssl \
# 	no-hw \
# 	no-srp \
# 	no-tests

make -j"${JOBS}"
# make install -j"${JOBS}"
make install_sw install_ssldirs
