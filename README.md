# rpi-alpine-build
MyLife Home alpine build on raspberry pi

## Usage

### Build packages (all arch)

```
scripts/build-packages.sh
```

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
- ancien setup: https://github.com/vincent-tr/rpi-image-builder/

## Rpi config initialization
- install base image on SD Card
- boot (with monitor and keyboard)
- Login root
- setup-alpine
    ```
    Keyboard layout: none (default)
    Hostname: todo-hostname
    Init interface : eth0 (default)
    IP adress: dhcp (default)
    Init interface: done (pas wlan0)
    Manuel net config: no (default)
    New pass for root: ###
    Timezone: Europe/Paris
    Proxy URL : none (default)
    Ntp client : chrony (default)
    Mirror URL: 1 (default)
    Ssh server: openssh (default)
    No available disk. Umount: no (default)
    Enter where to store config : mmcblk0p1 (default)
    Enter apk cache directory: /media/mmcblk0p1/cache (default)
    ```
- config sshd
  - vi /etc/ssh/sshd_config
      ```
      PermitRootLogin yes
      ```
  - service sshd restart
  - lbu commit
- add authorized keys:
  - cd /root
  - mkdir .ssh
  - chmod 700 .ssh
  - cd .ssh
  - cat > authorized_keys
  - <add pub key>
  - ctrl+D
  - chmod 600 authorized_keys
  - lbu add /root/.ssh/authorized_keys
  - lbu commit
- add custom repository
  - cat > /etc/apk/keys/mylife-home-builder.rsa.pub
  - <copy studio-data/build-secrets/abuild/mylife-home-builder.rsa.pub>
  - ctrl+D
  - echo "http://mylife-home-packages.apps.mti-team2.dyndns.org/alpine" >> /etc/apk/repositories
- reboot # (to be sure all is ok)
- at the end, retrieve the `/media/mmcblk0p1/todo-hostname.apkovl.tar.gz` file, it is config base
- locally:
  - mkdir root
  - put the `apkovl.tar.gz` file in root (note: archive content files/dirs must be owned by root/wheel (uid 0, gid 0))
  - tar -zcvf base-config.tar.gz root
  - upload `base-config.tar.gz` to studio files

## Install

### From Windows

 - https://github.com/garrym/raspberry-pi-alpine
   - dans le gestionnaire de disque, supprimer les partitions existantes
   - creer une partition FAT32 de 4096MB, label: "rpi-alpine"
   - copier/coller le contenu du .tar.gz
 - alt: sous windows il faut formatter la SD Card avec Rufus (sinon ca boot, mais le layout de /dev/mmblck*** est faux)

## TODO

- integrer les drivers:
  - https://github.com/mylife-home/mylife-home-drivers-pwm
  - https://github.com/mylife-home/mylife-home-drivers-ac

/******
=> mosquitto config-import:
vi /etc/mosquitto/mosquitto.conf
listener 1883 0.0.0.0
allow_anonymous true
*******/

OK => renommer mylife-home-[studio/deploy] en *-old (sur home-resources + DNS + portal)
OK => livrer le nouveau studio sur kube
OK => init mylife-home-studio-data

=> faire fonctionner rpi-home-main avec sa config
   => image-core-components -> faire une tache image-import-file pour importer les config ? dans "/media/mmcblk0p1/mylife-home" ?

=> livrer UI sur un nom temp et le faire fonctionner

=> renommer mylife-home-ui en *-old (sur home-resources + DNS + kube)
=> puis relivrer en reprenant l'ancien keycloak, et en mettant une route de l'ingress (ou gatekeeper) pour rediriger vers l'ancienne app genre home-ui.mylife.ovh/v1

## Notes

### home-resources content
 - http://home-resources/static/ (/var/www/static) => inspircd config + lirc config
 - http://home-resources/alpine-packages/ (var/www/alpine-packages) => alpine packages
 - vhosts configs vers studio, deploy, ui
 - /home/mylife-home : mylife-home-studio, mylife-home-resources, mylife-home-ui
 - /home/alpine-build : abuild keys, ssh keys, mylife-home-deploy + data