#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-snapshot-environment.sh"


## sshkey
ssh-keygen -t ed25519 -C "${HOSTNAME} backup" -N "" -f "${SSH_KEY}" || echo "using existing ssh key"


## init borg repo on server
echo "add borg user ${SERVER_USER}@${SERVER}"
ssh root@"${SERVER}" "adduser --disabled-password --gecos \"\" --home \"${SERVER_USER_HOME}\" ${SERVER_USER}" || echo "using existing user: ${SERVER_USER}"


declare -r SERVER_USER_BACKUP="${SERVER_USER_HOME}/backup"
ssh root@"${SERVER}" "mkdir -p \"${SERVER_USER_BACKUP}"\"
ssh root@"${SERVER}" "mkdir -p \"${SERVER_USER_HOME}/.ssh\""

echo "command=\"cd ${SERVER_USER_BACKUP} ; borg serve --append-only --restrict-to-path ${SERVER_USER_BACKUP}\",restrict $(cat "${SSH_KEY_PUB}")" | ssh root@"${SERVER}" "cat > \"${SERVER_USER_HOME}/.ssh/authorized_keys\""

ssh root@"${SERVER}" chown -R "${SERVER_USER}" "${SERVER_USER_HOME}/.ssh/"
ssh root@"${SERVER}" chgrp -R "${SERVER_USER}" "${SERVER_USER_HOME}/.ssh/"
ssh root@"${SERVER}" chmod -R og-rx "${SERVER_USER_HOME}/.ssh/"

echo "restricted user on server to borg: ${SERVER_USER}"


borg init --encryption=repokey
echo "success"
