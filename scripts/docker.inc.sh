function docker_init() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes
}

function docker_run_platforms() {
  local SCRIPT=$1

  docker_build_platform arm64v8 arm64 $SCRIPT # aarch64 (rpi2 V1.2, rpi3, rpi4)
  docker_build_platform arm32v6 arm $SCRIPT # armhf (rpi1, rpi0, rpi0w)
  docker_build_platform arm32v7 arm $SCRIPT # armv7l (rpi2 V1.1)
}

function docker_build_platform() {
  local ALPINE_IMAGE_PLATFORM=$1
  local DOCKER_PLATFORM=$2
  local SCRIPT=$3
  
  docker run \
    --platform linux/$DOCKER_PLATFORM --rm -ti \
    -v $BUILD_PATH/packages:/mnt/build \
    -v $(realpath ./scripts):/mnt/scripts:ro \
    -v $(realpath ./packages):/mnt/packages:ro \
    -v $(realpath $SECRETS_PATH):/mnt/build-secrets:ro \
    $ALPINE_IMAGE_PLATFORM/alpine:$ALPINE_VERSION \
    "/mnt/scripts/${SCRIPT}" \
    $(id -u) \
    $(id -g)
}