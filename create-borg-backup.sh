#!/bin/bash

set -eu -o pipefail

declare -rx BORG_PASSPHRASE="Test1234"
declare -rx BORG_RSH="ssh -i /home/ben/.ssh/id_borgbackup_ed25519"

function interrupted {
    echo "Backup interrupted"
}
trap interrupted INT TERM


borg create\
    --stats\
    --exclude "${HOME}/delme/now"\
    $(hostname)@backup:test::$(date "+%Y%m%d-%H%M%S")\
    "${HOME}/delme"
