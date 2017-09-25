#!/bin/sh

# Backup volumes.

cd "$(dirname "$0")"

# CHANGEME
DYNAMIC_VOLUMES="/srv/lava-compose/volumes/dynamic"
# CHANGEME
SERVICE_NAME="lava-compose.service"

if systemctl is-active "$SERVICE_NAME" ; then
    COMPOSE_IS_ACTIVE=0
    echo "Stopping ${SERVICE_NAME}..."
    systemctl stop "$SERVICE_NAME"
    echo "${SERVICE_NAME} stopped."
else
    echo "${SERVICE_NAME} is not running."
    COMPOSE_IS_ACTIVE=1
fi

DATETIME="$(date '+%F-%H%M%S')"
# CHANGEME
ARCHIVE_STEM="lava-volumes-dynamic-${DATETIME}"
echo "Creating backup ${ARCHIVE_STEM}..."
mkdir -p backups
#tar czf "backups/${ARCHIVE_STEM}.tgz" "$DYNAMIC_VOLUMES"
tar czf - "$DYNAMIC_VOLUMES" | split -b 1G --suffix-length 3 --numeric-suffix - "backups/${ARCHIVE_STEM}.tgz."
# To extract, do `cat foo-*.tgz.* | tar xf -`
echo "Backup done."

if [ "$COMPOSE_IS_ACTIVE" -eq 0 ] ; then
    echo "Starting ${SERVICE_NAME}..."
    systemctl start "$SERVICE_NAME"
    echo "${SERVICE_NAME} started."
fi
