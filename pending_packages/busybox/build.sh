#!/bin/sh

. ./config

## Prepare source
PKG_HOMEPAGE=https://busybox.net/
PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
PKG_LICENSE="GPL-2.0"

PKG_VERSION=1.36.1
PKG_BASENAME=busybox-${PKG_VERSION}
PKG_EXTNAME=.tar.bz2
PKG_SRCURL=https://busybox.net/downloads/${PKG_BASENAME}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

cp "${WORK_DIR}/packages/busybox/config.optmized" .config

patch <"${WORK_DIR}/packages/busybox/0000-use-clang.patch"
# patch -up1 <"${WORK_DIR}/packages/busybox/0001-clang-fix.patch" || true
patch -up1 <"${WORK_DIR}/packages/busybox/0012-util-linux-mount-no-addmntent.patch" || true
# find "${WORK_DIR}/packages/busybox" -name "*.patch" | while read -r file; do
# 	# patch --strip=1 --no-backup-if-mismatch --batch <"${file}"
# 	patch -up1 <"${file}" || true
# done

# Prevent spamming logs with useless warnings to make them more readable.
export CFLAGS="-Wno-ignored-optimization-argument -Wno-unused-command-line-argument"

if command -v "${TOOLCHAIN_BIN_DIR}/clang" >/dev/null; then
	HOSTCC="${TOOLCHAIN_BIN_DIR}/clang"
elif command -v gcc >/dev/null; then
	HOSTCC=gcc
fi

HOSTCC="zig cc --target=x86_64-linux-musl"

make ${HOSTCC:+HOSTCC="${HOSTCC}"} CC="${CC}" AR="${AR}" -j"${JOBS}" busybox_unstripped

"${OBJCOPY}" --strip-all busybox_unstripped busybox && chmod +x busybox
install -Dt "${OUTPUT_DIR}/bin" busybox
