#php initialisation
FROM php:8.2.0-cli

#dependencies
RUN apt-get update && apt-get install -y dos2unix
RUN apt-get install -y unzip

COPY --chmod=u+x bin/console bin/console
RUN dos2unix bin/console

#schedule shell
COPY --chmod=u+x docker/cron.sh cron.sh
RUN dos2unix cron.sh

COPY src src
COPY build build

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

COPY composer.lock .
COPY composer.json .

RUN composer install --prefer-dist

# webserver
FROM nginx:stable

# webserver config
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

