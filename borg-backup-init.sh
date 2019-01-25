#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-backup-environment.sh"


## sshkey
ssh-keygen -t ed25519 -C "${USER}@${HOSTNAME} backup" -N "" -f "${SSH_KEY}"


## init borg repo on server
ssh root@"${SERVER}" /opt/borg-server/add-borg-user.sh $(hostname) \"$(cat "${SSH_KEY}.pub")\"


borg init --encryption=repokey
echo "success"
