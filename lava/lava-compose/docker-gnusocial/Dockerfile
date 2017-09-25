FROM debian:stretch

ENV LANG C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && apt-get install -y \
    php7.0-bcmath php7.0-curl php7.0-exif php7.0-gd php7.0-intl \
    php7.0-mbstring php7.0-mysql php7.0-opcache php7.0-readline php7.0-xmlwriter \
    php7.0-fpm nginx-full rsync php7.0-gmp php7.0-json \
    git-core make gettext \
    curl php7.0-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# See http://php.net/manual/en/opcache.installation.php .
RUN sed -i \
        -e 's/^;\?\(opcache\.enable\)=.*$/\1=1/' \
        -e 's/^;\?\(opcache\.enable_cli\)=.*$/\1=1/' \
        -e 's/^;\?\(opcache\.memory_consumption\)=.*$/\1=128/' \
        -e 's/^;\?\(opcache\.interned_strings_buffer\)=.*$/\1=8/' \
        -e 's/^;\?\(opcache\.max_accelerated_files\)=.*$/\1=4000/' \
        -e 's/^;\?\(opcache\.revalidate_freq\)=.*$/\1=60/' \
        -e 's/^;\?\(opcache\.fast_shutdown\)=.*$/\1=1/' \
        /etc/php/7.0/fpm/php.ini \
    && sed -i \
        -e 's/^;\?\(listen\.owner\) *= *.*$/\1 = root/g' \
        -e 's/^;\?\(listen\.group\) *= *.*$/\1 = root/g' \
        -e 's/^;\?\(listen\.mode\) *= *.*$/\1 = 0660/g' \
        /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i \
        -e 's/^;\?\(memory_limit\) *= *.*$/\1 = 300M/g' \
        /etc/php/7.0/fpm/php.ini \
    && sed -i \
        -e 's/^;\?\(mysqli\.reconnect\)=.*$/\1=On/' \
        -e 's/^;\?\(mysqli\.allow_persistent\)=.*$/\1=On/' \
        -e 's/^;\?\(memory_limit\) *= *.*$/\1 = 300M/g' \
        /etc/php/7.0/cli/php.ini

COPY start.sh /start.sh
RUN chmod 500 /start.sh

EXPOSE 80
CMD ["/start.sh"]
