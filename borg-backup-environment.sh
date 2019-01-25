#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-backup-settings"

declare -r HOSTNAME=${HOSTNAME:-$(hostname)}
declare -r SERVER=${SERVER:-""}
declare -r SERVER_BACKUPS_DIRECTORY=${SERVER_BACKUPS_DIRECTORY:-"/srv/backup"}
declare -r SERVER_USER=${SERVER_USER:-"${HOSTNAME}"}
declare -r SERVER_USER_HOME="${SERVER_BACKUPS_DIRECTORY}/${SERVER_USER}"
declare -r SSH_KEY=${SSH_KEY:-"/root/.ssh/id_borgbackup_ed25519"}

declare -rx BORG_REPO=${BORG_REPO:-"${HOSTNAME}@${SERVER}:${HOSTNAME}"}
declare -rx BORG_PASSPHRASE=${BORG_PASSPHRASE:-""}
declare -rx BORG_RSH=${BORG_RSH:-"ssh -i \"${SSH_KEY}\""}
