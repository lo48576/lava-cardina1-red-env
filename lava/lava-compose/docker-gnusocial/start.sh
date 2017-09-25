#!/bin/sh
set -eu

sigterm_handler() {
    echo "Shutting down nginx (PID=${NGINX_PID})..."
    kill "${NGINX_PID}"
    echo 'nginx stopped.'
    echo 'Shutting down queuedaemons...'
    /var/www/gnusocial/scripts/stopdaemons.sh
    echo 'queuedaemons stopped.'
    echo 'Shutting down php7.0-fpm...'
    service php7.0-fpm stop
    echo 'php7.0-fpm stopped.'
    echo 'Bye.'
    exit 0
}

setup_plugin() {
    DIR_NAME="$1"
    REPO="$2"
    COMMIT="${3:-master}"
    ORIGIN_COMMIT="origin/${COMMIT}"
    PLUGIN_DIR="/var/www/gnusocial/local/plugins/${DIR_NAME}"

    echo "Setting up plugin: ${DIR_NAME}"
    if [ ! -d "$PLUGIN_DIR" ] ; then
        echo "Installing plugin: ${DIR_NAME}, commit ${COMMIT}"
        git clone "$REPO" "$PLUGIN_DIR"
        git checkout -f "${COMMIT}"
        echo "Install done: ${DIR_NAME}"
    else
        echo "Updating plugin: ${DIR_NAME}, commit ${COMMIT}"
        cd "$PLUGIN_DIR"
        git fetch || true
        git reset --hard "${ORIGIN_COMMIT}"
        git checkout -f "${COMMIT}"
        echo "Update done: ${DIR_NAME}"
    fi
}

: "Setup gnu-social" && {
    echo 'Setup gnu-social'
    cd /var/www/gnusocial
    BRANCH="instance/gnusocial.cardina1.red"
    if [ ! -d /var/www/gnusocial/.git ] ; then
        git init
        # CHANGEME if you want.
        git remote add origin https://github.com/lo48576/gnu-social.git
        git fetch
    fi
    git checkout "$BRANCH" && git pull --ff-only origin || {
        git fetch || true
        git reset --hard "origin/${BRANCH}"
        # Note that `git clean -df` may remove data directories (which should not be removed).
        #git clean -df
    }
    if [ -f config.php ] ; then
        chmod 644 config.php
    fi
}
: "Update l10n data" && {
    echo 'Update l10n data'
    cd /var/www/gnusocial
    make || {
        make clean
        make || true
    }
}


: "Install plugins" && {
    echo 'Install plugins'
    mkdir -p /var/www/gnusocial/local/plugins

    # Qvitter plugin.
    setup_plugin Qvitter https://git.gnu.io/h2p/Qvitter.git

    # QvitterPlus plugin.
    #setup_plugin QvitterPlus https://gitgud.io/panjoozek413/qvitterplus.git
    setup_plugin QvitterPlus https://gitgud.io/lo48576/qvitterplus.git fix/queetbox-behavior

    # GSGreenText plugin.
    # See https://gitgud.io/ShitposterClub/GSGreenText .
    setup_plugin GSGreenText https://gitgud.io/ShitposterClub/GSGreenText.git

    echo 'Plugins installed.'
}

: "Check DB schema" && {
    echo 'Check DB schema'
    # Should `checkschema.php` be executed when the gnusocial is running...?
    # You can do `sudo nsenter --target $(docker inspect --format '{{.State.Pid}}'  dockercompose_gnusocial_1) --mount --uts --ipc --net --pid` instead.
    # This would fail if the DB has not been initialized yet.
    php /var/www/gnusocial/scripts/checkschema.php -x TwitterBridge,InfiniteScroll,Qvitter,StoreRemoteMedia,QvitterPlus,GSGreenText || true
}

: "Prepare data directories" && {
    echo 'Prepare data directories'
    cd /var/www/gnusocial
    mkdir -p file avatar

    chmod a+w /var/www/gnusocial
    chmod a+w /var/www/gnusocial/avatar
    chmod a+w /var/www/gnusocial/file
}

: "Setup users" && {
    echo 'Setup users'
    if [ -f /var/www/gnusocial/config.php -a -f /initial_users.txt ] ; then
        cat /initial_users.txt | while read line ; do
            OP="$(echo "$line" | cut -d: -f1)"
            NICKNAME="$(echo "$line" | cut -d: -f2)"
            if echo "$line" | grep -q '^#' ; then
                OP="#"
            fi
            case "$OP" in
                'create')
                    PASSWORD="$(echo "$line" | cut -d: -f3 | base64 -d)"
                    # This will fail if the user already exists.
                    php /var/www/gnusocial/scripts/registeruser.php --nickname "$NICKNAME" --password "$PASSWORD" || true
                    echo "start.sh: created user '${NICKNAME}', with password '${PASSWORD}'"
                    ;;
                'delete')
                    # This will fail if the user doesn't exist.
                    php /var/www/gnusocial/scripts/deleteprofile.php --nickname "$NICKNAME" --yes || true
                    echo "start.sh: deleted user '${NICKNAME}'"
                    ;;
                '#')
                    : 'Comment line.'
                    ;;
                *)
                    echo "start.sh: unexpected op '${OP}'"
                    ;;
            esac
        done
    fi
}

cd

trap 'sigterm_handler' 1 2 3 15

echo 'starting php7.0-fpm for gnu-social'
#systemctl start php7.0-fpm
service php7.0-fpm start
echo 'php7.0-fpm started.'

echo 'starting queuedaemons'
/var/www/gnusocial/scripts/startdaemons.sh
echo 'queuedaemons started.'

echo 'starting nginx for gnu-social'
#/usr/bin/nginx -g "daemon off;"
nginx & NGINX_PID="${!}"

echo 'nginx started.'

sleep infinity & wait $!

# Should never be reached.
echo 'finished gnu-social `start.sh`'
