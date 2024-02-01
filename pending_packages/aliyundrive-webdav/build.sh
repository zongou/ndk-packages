#!/bin/sh

. ./config

## Prepare source
PKG_HOMEPAGE=https://github.com/messense/aliyundrive-webdav
PKG_DESCRIPTION="AliyunDrive webdav service"
PKG_LICENSE="MIT"

PKG_VERSION="2.3.3"
PKG_EXTNAME=.tar.gz
PKG_BASENAME=aliyundrive-webdav-${PKG_VERSION}
PKG_SRCURL=https://github.com/messense/aliyundrive-webdav/archive/refs/tags/v${PKG_VERSION}${PKG_EXTNAME}

get_source

cd "${BUILD_DIR}/aliyundrive-webdav-${PKG_VERSION}"

setup_rust_env
export RUSTFLAGS="-C link-arg=-s -C opt-level=s -C lto=true"
cargo build --release
install target/aarch64-linux-android/release/aliyundrive-webdav -D "${OUTPUT_DIR}/bin/aliyundrive-webdav"
