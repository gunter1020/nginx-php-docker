ARG PHP_VER=7.4
FROM php:${PHP_VER}-fpm-alpine

LABEL maintainer="Gunter Chou <abcd2221925@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV APP_DIR=/srv/app \
    WEB_ROOT=
ENV PHP_TIMEZONE=Asia/Taipei \
    PHP_MEMORY_LIMIT=256M \
    PHP_MAX_UPLOAD=20M \
    PHP_MAX_FILE_UPLOAD=20 \
    PHP_MAX_POST=100M \
    PHP_MAX_EXECUTION_TIME=60 \
    PHP_MAX_INPUT_VARS=1000 \
    PHP_TRACK_ERRORS=Off \
    PHP_SESS_SAVE_HANDLER=file \
    PHP_SESS_SAVE_PATH=/tmp \
    PHP_SESS_COOKIE_HTTPONLY=1 \
    PHP_SESS_GC_MAXLIFETIME=1440

# @see https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# @see https://github.com/docker-library/php/issues/240#issuecomment-305038173
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN apk --update-cache --no-cache add gnu-libiconv

#  Install PHP extensions
RUN install-php-extensions \
    # @composer \
    bz2 zip \
    # gd imagick \
    pdo_mysql redis \
    bcmath uuid \
    intl opcache

# Init PHP ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install Nginx
RUN apk --update-cache --no-cache add nginx

# Create application directory
RUN mkdir -p ${APP_DIR} && \
    chown www-data:www-data ${APP_DIR} && \
    chmod 777 ${APP_DIR}

# Add image files
COPY image-files/ /

# Entrypoint
COPY docker-app-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-app-entrypoint
ENTRYPOINT ["docker-app-entrypoint"]
CMD ["-g", "daemon off;"]

WORKDIR /srv/app

EXPOSE 80

STOPSIGNAL SIGQUIT
