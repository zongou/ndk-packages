#!/bin/sh

. ./config

PKG_HOMEPAGE=https://github.com/showwin/speedtest-go/
PKG_DESCRIPTION="Command line interface to test internet speed using speedtest.net"
PKG_LICENSE="MIT"

PKG_VERSION="1.6.10"
PKG_BASENAME=speedtest-go-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/showwin/speedtest-go/archive/refs/tags/v${PKG_VERSION}.tar.gz

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"
setup_go_env
go build -ldflags='-w -s'
install -Dt "${OUTPUT_DIR}/bin" speedtest-go
