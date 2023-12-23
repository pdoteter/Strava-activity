#php initialisation
FROM php:8.2.0-cli

#dependencies
RUN apt-get update && apt-get install -y \
#    dos2unix \
    unzip \
    nginx

ADD --chmod=u+x bin/console bin/console
#Be sure to set to LF in vscode RUN dos2unix bin/console

#schedule shell
ADD --chmod=u+x docker/cron.sh cron.sh
#Be sure to set to LF in vscode RUN dos2unix cron.sh

ADD src/** src
ADD build/** build

ADD composer.lock .
ADD composer.json .

ADD --chmod=u+x docker/docker-entrypoint.d /docker-entrypoint.d
ADD --chmod=u+x docker/docker-entrypoint.sh /usr/local/bin/
#Be sure to set to LF in vscode RUN dos2unix /usr/local/bin/docker-entrypoint.sh
#Be sure to set to LF in vscode RUN dos2unix /docker-entrypoint.d/*

# webserver config
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN composer install --prefer-dist

ENTRYPOINT [ "docker-entrypoint.sh" ]
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]