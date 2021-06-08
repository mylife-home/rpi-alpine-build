#!/bin/sh

#################################
# BASE
#################################

export ALPINE_VERSION=3.13.5

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes

#################################
# aarch64
#################################

# export LINUX_PLATFORM=aarch64 => unmae -m in container
export ALPINE_IMAGE_PLATFORM=arm64v8
export DOCKER_PLATFORM=arm64

SECRETS_PATH=../mylife-home-studio-data-dev/build-secrets
DIST_PATH=../mylife-home-main/packages/mylife-home-packager/dist

docker run --platform linux/$DOCKER_PLATFORM --rm -ti -v $(realpath ./scripts):/mnt/scripts -v $(realpath ./build):/mnt/build -v $(realpath $SECRETS_PATH):/mnt/build-secrets -v $(realpath $DIST_PATH):/mnt/dist $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION /mnt/scripts/container-build.sh
