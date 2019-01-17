#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-backup-settings"

declare -rx SERVER=${SERVER:-""}
declare -r  HOSTNAME=${HOSTNAME:-$(hostname)}
declare -rx SSH_KEY=${SSH_KEY:-"${HOME}/.ssh/id_borgbackup_ed25519"}
declare -rx BORG_REPO=${BORG_REPO:-"${HOSTNAME}@${SERVER}:${HOSTNAME}"}
declare -rx BORG_PASSPHRASE=${BORG_PASSPHRASE:-""}
declare -rx BORG_RSH=${BORG_RSH:-"ssh -i \"${SSH_KEY}\""}
