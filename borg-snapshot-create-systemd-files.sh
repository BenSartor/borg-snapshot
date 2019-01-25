#!/bin/bash

set -eu -o pipefail

declare -r SCRIPT_DIRECTORY=${SCRIPT_DIRECTORY:-$(dirname $(readlink -f $0))}
declare -r SYSTEMD_DIRECTORY=${SYSTEMD_DIRECTORY:-"/etc/systemd/system"}
declare -r DESCRIPTION=${DESCRIPTION:-"continuous invocation of borg backup"}

cat <<EOF > "${SYSTEMD_DIRECTORY}/borg-snapshot.service"
[Unit]
Description=${DESCRIPTION}
ConditionACPower=true
After=network.target network-online.target systemd-networkd.service NetworkManager.service connman.service

[Service]
Type=oneshot
ExecStart=${SCRIPT_DIRECTORY}/borg-snapshot-create.sh
EOF


cat <<EOF > "${SYSTEMD_DIRECTORY}/borg-snapshot.timer"
[Unit]
Description=${DESCRIPTION}

[Timer]
OnActiveSec=30s
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
EOF

echo "You may now run the following command to activate the systemd timer"
echo "  systemctl enable --now borg-snapshot.timer"
