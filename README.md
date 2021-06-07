# rpi-alpine-build
MyLife Home alpine build on raspberry pi

## Docs

- docker rpi emulation
  - https://hub.docker.com/r/rycus86/armhf-alpine-qemu
  - alpine qemu arm aarch64: https://superuser.com/questions/1397991/running-alpine-linux-on-qemu-arm-guests
  - docker pi for raspbian: https://github.com/lukechilds/dockerpi
  - custom qemu raspbian kernel: https://github.com/dhruvvyas90/qemu-rpi-kernel
  - cross-platform build tools: https://github.com/DDoSolitary/alpine-repo - https://github.com/DDoSolitary/alpine-repo/tree/docker
- open-rc daemon
  - https://stackoverflow.com/questions/8251933/how-can-i-log-the-stdout-of-a-process-started-by-start-stop-daemon
  - https://wiki.alpinelinux.org/wiki/Writing_Init_Scripts
  - https://wiki.gentoo.org/wiki/OpenRC/supervise-daemon#Services_which_won.27t_run_under_a_supervisor
  - https://github.com/OpenRC/openrc/blob/master/supervise-daemon-guide.md
- nrpe ?

## TODO

- recupérer la version du package.json du core/modules ?
- produire une image docker qui contient un web statique avec le repo APK ? comment gerer le fait d'avoir plusieurs versions de packages ?

Docker -v secrets folder
