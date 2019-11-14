#!/usr/bin/env sh

if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

curl https://get.acme.sh | ${SUDO} sh