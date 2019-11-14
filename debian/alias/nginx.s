#!/usr/bin/env sh

if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

${SUDO} service nginx stop
