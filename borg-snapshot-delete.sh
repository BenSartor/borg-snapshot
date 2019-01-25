#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-snapshot-environment.sh"


echo "remove user=${SERVER_USER} on server=${SERVER}"
ssh root@"${SERVER}" deluser --remove-home "${SERVER_USER}"

echo "remove user's home directory including backups: ${SERVER_USER_HOME}"
ssh root@"${SERVER}" rm -rf "${SERVER_USER_HOME}"

echo "delete ssh key create for borg"
rm "${SSH_KEY}"
rm "${SSH_KEY_PUB}"

echo "success"
