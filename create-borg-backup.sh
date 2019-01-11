#!/bin/bash

set -eu -o pipefail

declare -rx BORG_REPO="$(hostname)@backup:test"
declare -rx BORG_PASSPHRASE="Test1234"
declare -rx BORG_RSH="ssh -i \"${HOME}/.ssh/id_borgbackup_ed25519\""

declare -r TAG_PREFIX="cron-"

function interrupted {
    echo "Backup interrupted"
}
trap interrupted INT TERM



borg create\
    --stats\
    --exclude "${HOME}/delme/now"\
    ::${TAG_PREFIX}$(date "+%Y%m%d-%H%M%S")\
    "${HOME}/delme"


borg prune\
    --list\
    --prefix "${TAG_PREFIX}"\
    --keep-hourly  6\
    --keep-daily   7\
    --keep-weekly  4\
    --keep-monthly 6

borg list
echo "success"
