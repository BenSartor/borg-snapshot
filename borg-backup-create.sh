#!/bin/bash

set -eu -o pipefail

declare -r TAG_PREFIX="cron-"

. "$(dirname $(readlink -f $0))/borg-backup-environment.sh"

function interrupted {
    echo "Backup interrupted"
}
trap interrupted INT TERM


nice -n 19 ionice -c3 borg create                \
    --stats                                      \
    --exclude-caches                             \
    --exclude "/home/*/.cache"                   \
    --exclude "/home/*/.gradle"                  \
    --exclude "/home/*/.m2"                      \
    --exclude "/home/*/.steam/steam/steamapps/"  \
    --exclude "/home/*/.local/share/akonadi"     \
    --exclude "/home/*/Downloads"                \
    --exclude "/var/cache/"                      \
    --exclude "/var/tmp/"                        \
    --exclude "/var/lib/docker"                  \
    --exclude "/var/lib/flatpak"                 \
    --exclude "/tmp"                             \
    --exclude "/lost+found"                      \
    --exclude "/dev"                             \
    --exclude "/run"                             \
    --exclude "/sys"                             \
    --exclude "/proc"                            \
    ::${TAG_PREFIX}$(date "+%Y%m%d-%H%M%S")      \
    /


borg prune                      \
    --list                      \
    --prefix "${TAG_PREFIX}"    \
    --keep-secondly 4           \
    --keep-hourly   6           \
    --keep-daily    7           \
    --keep-weekly   4           \
    --keep-monthly  6

borg list
echo "success"
