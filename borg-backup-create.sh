#!/bin/bash

set -eu -o pipefail

declare -r BORG_BACKUP="$(dirname $(readlink -f $0))/borg-backup.sh"
declare -r TAG_PREFIX="cron-"

function interrupted {
    echo "Backup interrupted"
}
trap interrupted INT TERM


"${BORG_BACKUP}" create\
    --stats\
    --exclude "${HOME}/.cache"\
    --exclude "${HOME}/.gradle"\
    --exclude "${HOME}/.m2"\
    --exclude "${HOME}/.steam/steam/steamapps/"\
    --exclude "${HOME}/Downloads"\
    ::${TAG_PREFIX}$(date "+%Y%m%d-%H%M%S")\
    "${HOME}"


"${BORG_BACKUP}" prune\
    --list\
    --prefix "${TAG_PREFIX}"\
    --keep-secondly  4\
    --keep-hourly  6\
    --keep-daily   7\
    --keep-weekly  4\
    --keep-monthly 6

"${BORG_BACKUP}" list
echo "success"
