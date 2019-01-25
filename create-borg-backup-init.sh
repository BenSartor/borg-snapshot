#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/create-borg-backup-settings.sh"

declare -rx BORG_REPO=${BORG_REPO:-"$(hostname)@backup:home-$(whoami)"}
declare -rx BORG_PASSPHRASE=${BORG_PASSPHRASE:-""}
declare -rx BORG_RSH=${BORG_RSH:-"ssh -i \"${HOME}/.ssh/id_borgbackup_ed25519\""}

borg init --encryption=repokey
borg list
echo "success"
