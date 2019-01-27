#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-snapshot-environment.sh"

declare -r MOUNT_POINT=${MOUNT_POINT:-"/media/backup"}
mkdir -p "${MOUNT_POINT}"

borg mount "${BORG_REPO}" "${MOUNT_POINT}"
echo "mounted backup on: ${MOUNT_POINT}"
echo "you may umount it with:"
echo "  borg umount ${MOUNT_POINT}"
