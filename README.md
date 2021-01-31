# nginx-php-docker

## Version info

- Base on `php:${PHP_VER}-fpm-alpine` Docker image
- alpine `3.13.1`
- nginx `1.18.0`

## Links

- [GitHub - mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)
- [GitHub - gunter1020/nginx-php-docker](https://github.com/gunter1020/nginx-php-docker)
- [Docker Hub Overview page](https://hub.docker.com/r/gunter1020/nginx-php)

## Quick Start

### Pull image

  ```bash
  docker pull gunter1020/nginx-php:latest
  ```

### Running

  ```bash
  docker run -it --rm -p 8080:80 gunter1020/nginx-php
  ```

### Docker File

#### Dockerfile

  ```dockerfile
  FROM gunter1020/nginx-php
  WORKDIR /srv/app
  ADD composer.* /srv/app/
  RUN /usr/bin/composer install --prefer-dist
  ADD ./ /srv/app
  ENV PATH /srv/app/vendor/bin:${PATH}
  ```

#### docker-compose.yml

  ```dockerfile
  version: '3.8'
  services:
    app:
      image: gunter1020/nginx-php
      ports:
        - 8080:80
      volumes:
        - ./:/srv/app:delegated
      environment:
        # Path: `/srv/app/${WEB_ROOT}`
        WEB_ROOT: web
        # Basic
        PHP_TIMEZONE: Asia/Taipei
        PHP_TRACK_ERRORS: off
        PHP_MEMORY_LIMIT: 512M
        PHP_MAX_EXECUTION_TIME: 180
        # Request Limit
        PHP_MAX_UPLOAD: 50M
        PHP_MAX_FILE_UPLOAD: 20
        PHP_MAX_POST: 100M
        PHP_MAX_INPUT_VARS: 2000
        # Session
        PHP_SESS_SAVE_HANDLER: redis
        PHP_SESS_SAVE_PATH: tcp://redis.example.local:6379
        PHP_SESS_COOKIE_HTTPONLY: 1
        PHP_SESS_GC_MAXLIFETIME: 1440
  ```
