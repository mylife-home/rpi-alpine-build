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
- alpine repository
  - https://www.erianna.com/creating-a-alpine-linux-repository/
- nrpe ?

## Install

### From Windows

 - https://github.com/garrym/raspberry-pi-alpine
   - dans le gestionnaire de disque, supprimer les partitions existantes
   - creer une partition FAT32 de 4096MB, label: "rpi-alpine"
   - copier/coller le contenu du .tar.gz
 - sous windows il faut formatter la SD Card avec Rufus (sinon ca boot, mais le layout de /dev/mmblck*** est faux)

## TODO

- produire une image docker qui contient un web statique avec le repo APK ? comment gerer le fait d'avoir plusieurs versions de packages ?
   -- ou --
- host un nginx, avec un volume persistent, et ajouter de quoi upload dessus les resultats de build (+ index automatique ?)
