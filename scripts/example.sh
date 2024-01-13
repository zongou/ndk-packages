#!/bin/sh

## An example to build gnumake

ANDROID_API_LEVEL=24
for ANDROID_ABI in \
	aarch64-linux-android \
	armv7a-linux-androideabi \
	x86_64-linux-android \
	i686-linux-android; do
	export TARGET="${ANDROID_ABI}${ANDROID_API_LEVEL}"
	./packages/make/build.sh
done

find output -name make -type f | while read -r file; do
	file "${file}"
	du -ahd0 "${file}"
done
