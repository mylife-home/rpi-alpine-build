function docker_init() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes
}

function docker_run_platforms() {
  local SCRIPT=$1

  docker_build_platform arm32v6 arm armhf $SCRIPT # (rpi1, rpi0, rpi0w)
  docker_build_platform arm32v7 arm armv7l $SCRIPT # (rpi2 V1.1)
  docker_build_platform arm64v8 arm64 aarch64 $SCRIPT # (rpi2 V1.2, rpi3, rpi4)
}

function docker_build_platform() {
  local ALPINE_IMAGE_PLATFORM=$1
  local DOCKER_PLATFORM=$2
  local ARCH=$3
  local SCRIPT=$4
  
  docker run \
    --platform linux/$DOCKER_PLATFORM --rm -ti \
    -v $BUILD_PATH/packages:/mnt/build \
    -v $(realpath ./scripts):/mnt/scripts:ro \
    -v $(realpath ./packages):/mnt/packages:ro \
    -v $(realpath $SECRETS_PATH):/mnt/build-secrets:ro \
    $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION \
    "/mnt/scripts/${SCRIPT}" $(id -u) $(id -g) $ARCH
}
