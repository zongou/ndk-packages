#!/bin/sh

. ./config

## Prepare source
PKG_HOMEPAGE=https://github.com/zongou/libandroid-exec
PKG_DESCRIPTION="A execve() wrapper to fix problem with shebangs."
PKG_LICENSE="Apache-2.0"

PKG_VERSION=main
PKG_BASENAME=libandroid-exec-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/zongou/libandroid-exec/archive/refs/heads/main.tar.gz

get_source

cd "${BUILD_DIR}/${PKG_BASENAME}"
mkdir -p "${OUTPUT_DIR}/lib"

export LDFLAGS="-s"
make -B
make PREFIX="${OUTPUT_DIR}" install
