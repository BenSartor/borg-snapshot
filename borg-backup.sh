#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-backup-environment.sh"

borg $*
echo "success"
