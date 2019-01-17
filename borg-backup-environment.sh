#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-backup-settings"

declare -r  HOSTNAME=${HOSTNAME:-$(hostname)}
declare -rx BORG_REPO=${BORG_REPO:-"${HOSTNAME}@backup:${HOSTNAME}"}
declare -rx BORG_PASSPHRASE=${BORG_PASSPHRASE:-""}
declare -rx BORG_RSH=${BORG_RSH:-"ssh -i \"${HOME}/.ssh/id_borgbackup_ed25519\""}
