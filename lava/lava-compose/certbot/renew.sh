#!/bin/sh

# FIXME: May not work...

# Renew the cert.

cd "$(dirname "$0")"

VOLUMES="../volumes"
DYNAMIC_VOLUMES="${VOLUMES}/dynamic"
# CHANGEME
DOMAIN="gitlab.cardina1.red"

docker build --pull .
docker run --rm \
    -v "${DYNAMIC_VOLUMES}/certbot/etc-letsencrypt:/etc/letsencrypt" \
    -v "${DYNAMIC_VOLUMES}/certbot/var-lib-letsencrypt:/var/lib/letsencrypt" \
    -v "${DYNAMIC_VOLUMES}/certbot/var-log-letsencrypt:/var/log/letsencrypt" \
    -v "${DYNAMIC_VOLUMES}/nginx/html/certbot:/tmp/html" \
    certbot renew --webroot -w /tmp/html
