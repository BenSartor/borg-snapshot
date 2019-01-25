#!/bin/bash

set -eu -o pipefail

. "$(dirname $(readlink -f $0))/borg-snapshot-environment.sh"

borg $*
echo "success"
