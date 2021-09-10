#!/bin/sh

source "scripts/defines.inc.sh"
source "scripts/docker.inc.sh"

function main() {
  docker_init

  # Init build dir
  mkdir -p $BUILD_PATH/packages # to be created with right user
  rm -rf $BUILD_PATH/packages/*

  docker_run_platforms build_platform

  # Build docker image
  # cp ./docker/packages/* ./build
  # docker build --pull -t vincenttr/mylife-home-packages-repository:$REPOSITORY_VERSION ./build
  # docker push vincenttr/mylife-home-packages-repository:$REPOSITORY_VERSION
}

function build_platform() {
  local ALPINE_IMAGE_PLATFORM=$1
  local DOCKER_PLATFORM=$2
  
  docker run --platform linux/$DOCKER_PLATFORM --rm -ti -v $BUILD_PATH/packages:/mnt/build -v $(realpath ./scripts):/mnt/scripts:ro -v $(realpath ./packages):/mnt/packages:ro -v $(realpath $SECRETS_PATH):/mnt/build-secrets:ro $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION /mnt/scripts/container-build-packages.sh $(id -u) $(id -g)
}

main
