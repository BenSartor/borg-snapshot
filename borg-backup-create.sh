#!/bin/bash

set -eu -o pipefail

declare -r BORG_BACKUP="$(dirname $(readlink -f $0))/borg-backup.sh"
declare -r TAG_PREFIX="cron-"

function interrupted {
    echo "Backup interrupted"
}
trap interrupted INT TERM


nice -n 19 ionice -c3 "${BORG_BACKUP}" create\
    --stats\
    --exclude "/home/*/.cache"\
    --exclude "/home/*/.gradle"\
    --exclude "/home/*/.m2"\
    --exclude "/home/*/.steam/steam/steamapps/"\
    --exclude "/home/*/.local/share/akonadi"\
    --exclude "/home/*/Downloads"\
    --exclude "/var/cache/"\
    --exclude "/var/tmp/"\
    --exclude "/var/lib/flatpak"\
    ::${TAG_PREFIX}$(date "+%Y%m%d-%H%M%S")\
    /etc\
    /home\
    /opt\
    /root\
    /srv\
    /usr\
    /var


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
