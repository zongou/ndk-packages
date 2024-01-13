#!/bin/sh

. ./config

"${WORK_DIR}/packages/libtalloc/build.sh"

PKG_HOMEPAGE=https://proot-me.github.io/
PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
PKG_LICENSE="GPL-2.0"
PKG_MAINTAINER="Michal Bednarski @michalbednarski"
# Just bump commit and version when needed:
PKG_VERSION=5.1.107
# PKG_REVISION=62
PKG_EXTNAME=.tar.gz
PKG_BASENAME=proot-master
PKG_SRCURL=https://github.com/termux/proot/archive/master${PKG_EXTNAME}
# PKG_EXTRA_MAKE_ARGS="-C src"

# get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"
# patch -up1 <"${WORK_DIR}/packages/proot/base.patch"
# patch -up1 <"${WORK_DIR}/packages/proot/proot-try-TMPDIR.patch"
cd src

export CFLAGS="-I${OUTPUT_DIR}/include"
export LDFLAGS="-L${OUTPUT_DIR}/lib"
# export PROOT_UNBUNDLE_LOADER='../libexec/proot'

# export CFLAGS="-I${OUTPUT_DIR}/include -Werror=implicit-function-declaration -flto"
# export LDFLAGS="-L${OUTPUT_DIR}/lib -static -ffunction-sections -fdata-sections -Wl,--gc-sections -s"

# export CFLAGS="-I${OUTPUT_DIR}/include -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"

export CFLAGS="-I${OUTPUT_DIR}/include -Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
export LDFLAGS="-L${OUTPUT_DIR}/lib -Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

make distclean || true
# export OBJCOPY="zig objcopy"
make V=1 "PREFIX=${OUTPUT_DIR}" -j"${JOBS}" install

file proot
du -ahd0 proot
ldd proot
