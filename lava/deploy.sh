#!/bin/sh
set -xeu

cd "$(dirname "$0")"

# CHANGEME
mkdir -p /srv
# CHANGEME
cp -a ./lava-compose /srv/
cp -a ./systemd-system/* /etc/systemd/system
cp -a ./sysctl-d/* /etc/sysctl.d/
: "Change accept_ra config" && {
    # Create a backup.
    cp -f /etc/network/interfaces /etc/network/interfaces.bkp-lo48576
    # Change the config.
    sed -i /etc/network/interfaces -e 's/^accept_ra\s\s*[0-2]$/accept_ra 2/g'
}
systemctl daemon-reload
systemctl enable certbot.timer
#systemctl enable certbot.service
systemctl enable gnusocial-maintenance.timer
#systemctl enable gnusocial-maintenance.service
systemctl enable install-docker-compose
systemctl enable lava-compose
systemctl enable systemd-sysctl
