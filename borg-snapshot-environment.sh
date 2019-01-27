#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-snapshot-settings"

declare -r HOSTNAME=${HOSTNAME:-$(hostname)}
declare -r SERVER=${SERVER:-""}
declare -r SERVER_BACKUPS_DIRECTORY=${SERVER_BACKUPS_DIRECTORY:-"/srv/backup"}
declare -r SERVER_USER=${SERVER_USER:-"${HOSTNAME}"}
declare -r SERVER_USER_HOME="${SERVER_BACKUPS_DIRECTORY}/${SERVER_USER}"

declare -r SSH_KEY=${SSH_KEY:-"/root/.ssh/id_borg-snapshot_ed25519"}
declare -r SSH_KEY_PUB=${SSH_KEY_PUB:-"${SSH_KEY}.pub"}
declare -r SYSTEMD_DIRECTORY=${SYSTEMD_DIRECTORY:-"/etc/systemd/system"}
declare -r SYSTEMD_SERVICE=${SYSTEMD_SERVICE:-"${SYSTEMD_DIRECTORY}/borg-snapshot.service"}
declare -r SYSTEMD_TIMER=${SYSTEMD_TIMER:-"${SYSTEMD_DIRECTORY}/borg-snapshot.timer"}


declare -rx BORG_REPO=${BORG_REPO:-"${SERVER_USER}@${SERVER}:${HOSTNAME}"}
declare -rx BORG_PASSPHRASE=${BORG_PASSPHRASE:-""}
declare -rx BORG_RSH=${BORG_RSH:-"ssh -i \"${SSH_KEY}\""}
