#!/bin/sh

#################################
# BASE
#################################

export ALPINE_VERSION=3.13.5

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

#################################
# aarch64
#################################

# export LINUX_PLATFORM=aarch64 => unmae -m in container
export ALPINE_IMAGE_PLATFORM=arm64v8
export DOCKER_PLATFORM=arm64

docker run --platform linux/$DOCKER_PLATFORM --rm -ti -v $(realpath ./build):/build -v $(realpath ../mylife-home-studio-data-dev/build-secrets):/build-secrets $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION /build/container-build.sh