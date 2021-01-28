#!/bin/sh
set -e

# Sed PHP environments
sed -i "s|;*date.timezone =.*|date.timezone = ${PHP_TIMEZONE}|i" /etc/php7/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
sed -i "s|;*max_execution_time =.*|max_execution_time = ${PHP_MAX_EXECUTION_TIME}|i" /etc/php7/php.ini
sed -i "s|;*max_input_vars =.*|max_input_vars = ${PHP_MAX_INPUT_VARS}|i" /etc/php7/php.ini
sed -i "s|;*track_errors =.*|track_errors = ${PHP_TRACK_ERRORS}|i" /etc/php7/php.ini
sed -i "s|;*session\.save_handler =.*|session\.save_handler = ${PHP_SESS_SAVE_HANDLER}|i" /etc/php7/php.ini
sed -i "s|;*session\.save_path =.*|session\.save_path = ${PHP_SESS_SAVE_PATH}|i" /etc/php7/php.ini
sed -i "s|;*session\.cookie_httponly =.*|session\.cookie_httponly = ${PHP_SESS_COOKIE_HTTPONLY}|i" /etc/php7/php.ini
sed -i "s|;*session\.gc_maxlifetime =.*|session\.gc_maxlifetime = ${PHP_SESS_GC_MAXLIFETIME}|i" /etc/php7/php.ini

# Sed Nginx environments
sed -i "s|{{NGINX_ROOT}}|${APP_DIR}/${WEB_ROOT}|i" /etc/nginx/conf.d/default.conf

# Start PHP-FPM
php-fpm

case "$1" in
    sh|bash)
        # Start Nginx
        nginx
        set -- "$@"
    ;;
    *)
        # Start Nginx with daemon off
        set -- nginx "$@"
    ;;
esac

exec "$@"