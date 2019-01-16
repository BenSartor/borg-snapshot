#!/bin/bash

set -eu -o pipefail

declare -rx BORG_REPO="$(hostname)@backup:home-$(whoami)"
declare -rx BORG_PASSPHRASE="Test1234"
declare -rx BORG_RSH="ssh -i \"${HOME}/.ssh/id_borgbackup_ed25519\""

declare -r TAG_PREFIX="cron-"

function interrupted {
    echo "Backup interrupted"
}
trap interrupted INT TERM


#borg init --encryption=repokey

borg create\
    --stats\
    --exclude "${HOME}/.cache"\
    --exclude "${HOME}/.gradle"\
    --exclude "${HOME}/.m2"\
    --exclude "${HOME}/.steam/steam/steamapps/"\
    --exclude "${HOME}/Downloads"\
    ::${TAG_PREFIX}$(date "+%Y%m%d-%H%M%S")\
    "${HOME}"


borg prune\
    --list\
    --prefix "${TAG_PREFIX}"\
    --keep-secondly  4\
    --keep-hourly  6\
    --keep-daily   7\
    --keep-weekly  4\
    --keep-monthly 6

borg list
echo "success"
