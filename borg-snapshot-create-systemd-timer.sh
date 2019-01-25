#!/bin/bash

set -eu -o pipefail

declare -r SCRIPT_DIRECTORY=${SCRIPT_DIRECTORY:-$(dirname $(readlink -f $0))}
declare -r DESCRIPTION=${DESCRIPTION:-"continuous invocation of borg backup"}

. "${SCRIPT_DIRECTORY}/borg-snapshot-environment.sh"


echo "create systemd file: ${SYSTEMD_SERVICE}"
cat <<EOF > "${SYSTEMD_SERVICE}"
[Unit]
Description=${DESCRIPTION}
ConditionACPower=true
After=network.target network-online.target systemd-networkd.service NetworkManager.service connman.service

[Service]
Type=oneshot
ExecStart=${SCRIPT_DIRECTORY}/borg-snapshot-create.sh
EOF


echo "create systemd file: ${SYSTEMD_TIMER}"
cat <<EOF > "${SYSTEMD_TIMER}"
[Unit]
Description=${DESCRIPTION}

[Timer]
OnActiveSec=30s
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
EOF


echo "start systemd timer"
systemctl enable --now borg-snapshot.timer


echo "You may now run the following command to watch log files"
echo "  journalctl -f -u borg-snapshot.service"
