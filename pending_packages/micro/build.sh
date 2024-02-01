#!/bin/sh

. ./config

## Prepare source
PKG_HOMEPAGE=https://micro-editor.github.io/
PKG_DESCRIPTION="Modern and intuitive terminal-based text editor"
PKG_LICENSE="MIT"
PKG_VERSION="2.0.13"

PKG_BASENAME=micro-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://github.com/zyedidia/micro/archive/refs/tags/v${PKG_VERSION}${PKG_EXTNAME}

get_source

cd "${BUILD_DIR}/micro-${PKG_VERSION}"

setup_go_env
# VERSION="$(GOOS=$(go env GOHOSTOS) GOARCH=$(go env GOHOSTARCH) go run tools/build-version.go)"
VERSION="${PKG_VERSION}"
DATE="$(GOOS=$(go env GOHOSTOS) GOARCH=$(go env GOHOSTARCH) go run tools/build-date.go)"
HASH="68d88b57"
GOVARS="-X github.com/zyedidia/micro/v2/internal/util.Version=${VERSION} -X github.com/zyedidia/micro/v2/internal/util.CommitHash=${HASH} -X 'github.com/zyedidia/micro/v2/internal/util.CompileDate=${DATE}'"

go build -trimpath -ldflags "-s -w ${GOVARS}" ./cmd/micro
install -Dt "${OUTPUT_DIR}/bin" micro
