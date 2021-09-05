#!/bin/sh

REPOSITORY_VERSION=1.0.5
ALPINE_VERSION=3.13.5
SECRETS_PATH=$(realpath ../mylife-home-studio-data-dev/build-secrets)
BUILD_PATH=$(realpath ./build)

function init() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes

  mkdir -p $BUILD_PATH/packages # to be created with right user
  rm -rf $BUILD_PATH/packages/*
}

function build_platform() {
  local ALPINE_IMAGE_PLATFORM=$1
  local DOCKER_PLATFORM=$2
  
  docker run --platform linux/$DOCKER_PLATFORM --rm -ti -v $BUILD_PATH/packages:/mnt/build -v $(realpath ./scripts):/mnt/scripts:ro -v $(realpath ./packages):/mnt/packages:ro -v $(realpath $SECRETS_PATH):/mnt/build-secrets:ro $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION /mnt/scripts/container-build-packages.sh $(id -u) $(id -g)
}

function build_docker() {
  cp ./docker/packages/* ./build
  docker build --pull -t vincenttr/mylife-home-packages-repository:$REPOSITORY_VERSION ./build
  docker push vincenttr/mylife-home-packages-repository:$REPOSITORY_VERSION
}

init
build_platform arm64v8 arm64 # aarch64 (rpi2 V1.2, rpi3, rpi4)
build_platform arm32v6 arm # armhf (rpi1, rpi0, rpi0w)
build_platform arm32v7 arm # armv7l (rpi2 V1.1)
build_docker