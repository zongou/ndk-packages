#!/bin/sh
set -eu

. ./config

## Prepare source
PKG_HOMEPAGE=https://www.gnu.org/software/make/
PKG_DESCRIPTION="Tool to control the generation of non-source files from source files"
PKG_LICENSE="GPL-3.0"

PKG_VERSION="4.4.1"
PKG_BASENAME=make-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL="${GNU_MIRROR}/gnu/make/make-${PKG_VERSION}${PKG_EXTNAME}"

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

# Prevent linking against libelf:
EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} ac_cv_lib_elf_elf_begin=no"
# Prevent linking against libiconv:
EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} am_cv_func_iconv=no"
# Prevent linking against guile:
EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} --without-guile"

if test "$TARGET" = "armv7a*"; then
	# Fix issue with make on arm hanging at least under cmake:
	# https://github.com/termux/termux-packages/issues/2983
	EXTRA_CONFIGURE_ARGS="${EXTRA_CONFIGURE_ARGS:-} ac_cv_func_pselect=no"
fi

## Small build, stripped
export CFLAGS="-Os -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
export LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections"

# shellcheck disable=SC2086
./configure \
	${EXTRA_CONFIGURE_ARGS} \
	--host="${TARGET}" \
	--prefix="${OUTPUT_DIR}"

if command -v make >/dev/null; then
	make -j"${JOBS}" install
else
	./build.sh
	mkdir -p "${OUTPUT_DIR}/bin"
	install make "${OUTPUT_DIR}/bin/make"
fi
