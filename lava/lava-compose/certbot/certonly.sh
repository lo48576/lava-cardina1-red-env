#!/bin/sh

# FIXME: May not work...

# Gets a new cert.

cd "$(dirname "$0")"

VOLUMES="../volumes"
DYNAMIC_VOLUMES="${VOLUMES}/dynamic"
# CHANGEME
DOMAIN="gitlab.cardina1.red"

docker build --pull .
docker run -it \
    -v "${DYNAMIC_VOLUMES}/certbot/etc-letsencrypt:/etc/letsencrypt" \
    -v "${DYNAMIC_VOLUMES}/certbot/var-lib-letsencrypt:/var/lib/letsencrypt" \
    -v "${DYNAMIC_VOLUMES}/certbot/var-log-letsencrypt:/var/log/letsencrypt" \
    -v "${DYNAMIC_VOLUMES}/nginx/html/certbot:/tmp/html" \
    certbot certonly --webroot -w /tmp/html -d "${DOMAIN}"
#sudo openssl dhparam 2048 -out /etc/letsencrypt/live/dhparam_2048_20161002.pem
#sudo openssl dhparam 2048 -out /etc/letsencrypt/dhparam_2048_$(date '+%Y%m%d').pem
