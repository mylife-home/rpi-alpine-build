#!/bin/sh
set -e

source "scripts/defines.inc.sh"
source "scripts/docker.inc.sh"

function main() {
  docker_init

  # Init build dir
  mkdir -p $BUILD_PATH/packages # to be created with right user
  rm -rf $BUILD_PATH/packages/*

  docker_run_platforms container-build-packages.sh

  # Build docker image
  cp ./docker/packages/* ./build
  docker build --pull -t vincenttr/mylife-home-packages-repository:$DOCKER_PACKAGES_REPOSITORY_VERSION ./build
  docker push vincenttr/mylife-home-packages-repository:$DOCKER_PACKAGES_REPOSITORY_VERSION
}

main
