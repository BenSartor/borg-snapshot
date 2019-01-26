#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-snapshot-environment.sh"


if [ -e "${SYSTEMD_SERVICE}" ] ; then
    echo "remove systemd timer"
    systemctl disable borg-snapshot.timer
    rm "${SYSTEMD_SERVICE}"
    rm "${SYSTEMD_TIMER}"
fi

echo "remove user=${SERVER_USER} on server=${SERVER}"
ssh root@"${SERVER}" deluser --remove-home "${SERVER_USER}"

echo "remove user's home directory on server including backups: ${SERVER_USER_HOME}"
ssh root@"${SERVER}" rm -rf "${SERVER_USER_HOME}"

echo "delete ssh key created for borg"
rm "${SSH_KEY}"
rm "${SSH_KEY_PUB}"

echo "success"
