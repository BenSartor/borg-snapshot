#!/bin/bash

set -eu -o pipefail

declare -r SCRIPT_DIRECTORY=${SCRIPT_DIRECTORY:-$(dirname $(readlink -f $0))}
declare -r DESTINATION_DIRECTORY=${DESTINATION_DIRECTORY:-"/etc/systemd/system"}
declare -r DESCRIPTION=${DESCRIPTION:-"continuous invocation of borg backup"}

cat <<EOF > "${DESTINATION_DIRECTORY}/borg-backup.service"
[Unit]
Description=${DESCRIPTION}
ConditionACPower=true
After=network.target network-online.target systemd-networkd.service NetworkManager.service connman.service

[Service]
Type=oneshot
ExecStart=${SCRIPT_DIRECTORY}/borg-backup-create.sh
EOF


cat <<EOF > "${DESTINATION_DIRECTORY}/borg-backup.timer"
[Unit]
Description=${DESCRIPTION}

[Timer]
OnActiveSec=30s
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
EOF

echo "success"
