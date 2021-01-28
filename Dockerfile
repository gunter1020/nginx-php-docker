ARG ALPINE_VER=3.12
FROM alpine:${ALPINE_VER}

LABEL maintainer="Gunter Chou <abcd2221925@gmail.com>"

ARG ALPINE_VER
ENV DEBIAN_FRONTEND=noninteractive
ENV PHP_VER=7.4 \
    PHP_TIMEZONE=Asia/Taipei \
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

# @see https://github.com/codecasts/php-alpine
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update-cache --no-cache add curl ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v${ALPINE_VER}/php-${PHP_VER}" >> /etc/apk/repositories

# Install PHP
RUN apk --update-cache --no-cache add \
    # Core
    php \
    php-fpm \
    # Core Extension
    php-bcmath \
    php-bz2 \
    php-curl \
    php-dom \
    php-gd \
    php-iconv \
    php-intl \
    php-json \
    php-mbstring \
    php-opcache \
    php-openssl \
    php-pcntl \
    php-pdo_mysql \
    php-phar \
    php-session \
    php-xml \
    php-xmlreader \
    php-xmlrpc \
    php-xsl \
    php-zip \
    php-zlib \
    # Extra Extension
    php-imagick \
    php-memcached \
    php-psr \
    php-redis

# Alias PHP bin
RUN ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm

# Sed PHP environments
RUN sed -i "s|;*date.timezone =.*|date.timezone = ${PHP_TIMEZONE}|i" /etc/php7/php.ini && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
    sed -i "s|;*max_execution_time =.*|max_execution_time = ${PHP_MAX_EXECUTION_TIME}|i" /etc/php7/php.ini && \
    sed -i "s|;*max_input_vars =.*|max_input_vars = ${PHP_MAX_INPUT_VARS}|i" /etc/php7/php.ini && \
    sed -i "s|;*track_errors =.*|track_errors = ${PHP_TRACK_ERRORS}|i" /etc/php7/php.ini && \
    sed -i "s|;*session\.save_handler =.*|session\.save_handler = ${PHP_SESS_SAVE_HANDLER}|i" /etc/php7/php.ini && \
    sed -i "s|;*session\.save_path =.*|session\.save_path = ${PHP_SESS_SAVE_PATH}|i" /etc/php7/php.ini && \
    sed -i "s|;*session\.cookie_httponly =.*|session\.cookie_httponly = ${PHP_SESS_COOKIE_HTTPONLY}|i" /etc/php7/php.ini && \
    sed -i "s|;*session\.gc_maxlifetime =.*|session\.gc_maxlifetime = ${PHP_SESS_GC_MAXLIFETIME}|i" /etc/php7/php.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/bin \
        --filename=composer && \
    composer clear-cache

# Install Nginx
RUN apk --update-cache --no-cache add nginx

# Create application directory
RUN mkdir -p /srv/app && \
    chown nginx:nginx /srv/app && \
    chmod 777 /srv/app

# Add image files
COPY image-files/ /

# Entry point
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-g", "daemon off;"]

WORKDIR /srv/app

EXPOSE 80

STOPSIGNAL SIGQUIT
