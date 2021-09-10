#!/bin/sh
set -e

source "scripts/defines.inc.sh"
source "scripts/docker.inc.sh"

function main() {
  docker_init

  # Init build dir
  mkdir -p $BUILD_PATH/kernel # to be created with right user
  rm -rf $BUILD_PATH/kernel/*

  docker_run_platforms container-build-kernel.sh
}

main
