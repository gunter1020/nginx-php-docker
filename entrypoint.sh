#!/bin/sh
set -e

php-fpm

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- nginx "$@"
    ;;
esac

exec "$@"