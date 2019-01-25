#!/bin/bash

set -eu -o pipefail

declare -r SCRIPT_DIRECTORY=${SCRIPT_DIRECTORY:-$(dirname $(readlink -f $0))}
declare -r SYSTEMD_DIRECTORY=${SYSTEMD_DIRECTORY:-"/etc/systemd/system"}
declare -r SYSTEMD_SERVICE=${SYSTEMD_SERVICE:-"${SYSTEMD_DIRECTORY}/borg-snapshot.service"}
declare -r SYSTEMD_TIMER=${SYSTEMD_TIMER:-"${SYSTEMD_DIRECTORY}/borg-snapshot.timer"}
declare -r DESCRIPTION=${DESCRIPTION:-"continuous invocation of borg backup"}

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

echo "You may now run the following command to activate the systemd timer"
echo "  systemctl enable --now borg-snapshot.timer"
