#!/bin/sh

. ./config

PKG_HOMEPAGE=https://github.com/cloudflare/cloudflared
PKG_DESCRIPTION="A tunneling daemon that proxies traffic from the Cloudflare network to your origins"
PKG_LICENSE="Apache-2.0"

PKG_VERSION="2024.1.0"
PKG_BASENAME=cloudflared-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/cloudflare/cloudflared/archive/refs/tags/${PKG_VERSION}${PKG_EXTNAME}

get_source
cd "${BUILD_DIR}/${PKG_BASENAME}"

setup_go_env
_DATE=$(date -u '+%Y.%m.%d-%H:%M UTC')
go build -v -ldflags "-w -s -X \"main.Version=${PKG_VERSION}\" -X \"main.BuildTime=$_DATE\"" \
	./cmd/cloudflared

install -Dm700 -t "${OUTPUT_DIR}/bin" cloudflared
