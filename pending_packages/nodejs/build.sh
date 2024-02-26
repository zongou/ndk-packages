#!/bin/sh
set -eux

. ./config

# gcc >= 6.3.0
# ANDROID_TARGET_API (ANDROID_SDK_VERSION) >= 24

PKG_HOMEPAGE=https://nodejs.org/
PKG_DESCRIPTION="Open Source, cross-platform JavaScript runtime environment"
PKG_LICENSE="MIT"

PKG_VERSION=21.6.2
PKG_BASENAME=node-v${PKG_VERSION}
PKG_EXTNAME=.tar.xz
# PKG_SRCURL=https://nodejs.org/dist/v${PKG_VERSION}/node-v${PKG_VERSION}${PKG_EXTNAME}
PKG_SRCURL=https://mirrors.ustc.edu.cn/node/v${PKG_VERSION}/node-v${PKG_VERSION}${PKG_EXTNAME}

get_source

cd "${BUILD_DIR}/${PKG_BASENAME}"

## Fix trap-handler
patch -f ./deps/v8/src/trap-handler/trap-handler.h -up1 <"${WORK_DIR}/pending_packages/nodejs/21.x.fixed-trap-handler.patch"

## Fix ../deps/zlib/cpu_features.c:43:10: fatal error: 'cpu-features.h' file not found
export CFLAGS=" -I${ANDROID_NDK_ROOT}/sources/android/cpufeatures"

## Fix ../deps/v8/src/base/debug/stack_trace_posix.cc:156:9: error: use of undeclared identifier 'backtrace_symbols'
echo >test/cctest/test_crypto_clienthello.cc

## Fix g++: error: unrecognized command-line option ‘-mbranch-protection=standard’
patch -up1 <"${WORK_DIR}/pending_packages/nodejs/node_gyp_mbranch-protection.patch"

case "${TARGET}" in
aarch64-linux-android*)
	DEST_CPU="arm64"
	TARGET_ARCH="arm64"
	HOST_M32=""
	;;
armv7a-linux-androideabi*)
	DEST_CPU="arm"
	HOST_M32=" -m32"
	;;
x86_64-linux-android*)
	DEST_CPU="x64"
	TARGET_ARCH="x64"
	HOST_M32=""
	;;
i686-linux-android*)
	DEST_CPU="ia32"
	HOST_M32=" -m32"
	;;
*) ;;
esac

HOST_OS=$(uname -m)
export GYP_DEFINES="\
	target_arch=${TARGET_ARCH} \
	v8_target_arch=${TARGET_ARCH} \
	android_target_arch=${TARGET_ARCH} \
	host_os=${HOST_OS} \
	OS=android \
	android_ndk_path=${ANDROID_NDK_ROOT}"

export CXXLASGS=" -Wno-unused-command-line-argument"
CC_host="gcc${HOST_M32}"
CXX_host="g++${HOST_M32}"
export CC_host CXX_host

build_with_make() {
	./configure \
		--dest-cpu="${DEST_CPU}" \
		--dest-os=android \
		--openssl-no-asm \
		--cross-compiling \
		--partly-static \
		--prefix="${OUTPUT_DIR}"

	make -j"${JOBS}"
}

build_with_ninja() {
	patch -up1 <"${WORK_DIR}/pending_packages/nodejs/build_with_ninja.patch"

	./configure \
		--dest-cpu="${DEST_CPU}" \
		--dest-os=android \
		--openssl-no-asm \
		--cross-compiling \
		--partly-static \
		--prefix="${OUTPUT_DIR}" \
		--ninja

	ninja -C out/Release -j"${JOBS}"
}

build_with_ninja
