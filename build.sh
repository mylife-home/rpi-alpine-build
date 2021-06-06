#!/bin/sh

export ALPINE_VERSION=3.13.5
# export LINUX_PLATFORM=aarch64 => unmae -m in container
export ALPINE_IMAGE_PLATFORM=arm64v8
export DOCKER_PLATFORM=arm64

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker run --platform linux/$DOCKER_PLATFORM --rm -ti -v $(realpath ./build):/build $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION /bin/sh