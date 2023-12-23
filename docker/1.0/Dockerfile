#php initialisation
FROM php:8.2.0-cli

#dependencies
RUN apt-get update && apt-get install -y \
    dos2unix \
    unzip \
    nginx

COPY --chmod=u+x bin/console bin/console
RUN dos2unix bin/console

#schedule shell
COPY --chmod=u+x cron.sh cron.sh
RUN dos2unix cron.sh

COPY src src
COPY build build

COPY composer.lock .
COPY composer.json .

COPY docker-entrypoint.d /docker-entrypoint.d
COPY docker-entrypoint.sh /docker-entrypoint.sh

# webserver config
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN composer install --prefer-dist

ENTRYPOINT [ "docker-entrypoint.sh" ]
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]