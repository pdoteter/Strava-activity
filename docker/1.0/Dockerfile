#php initialisation
FROM php:8.2.0-cli

#dependencies
#node.js V20
RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN NODE_MAJOR=20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update

RUN apt-get install -y \
    dos2unix \
    unzip \
    cron \
    git \
    node.js \
    npm \
    nginx

#Our app stuff
WORKDIR /strava
ADD src/** src
ADD build/** build
ADD echart.js .

# php composer
ADD composer.lock .
ADD composer.json .

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

# will be run in cron.sh RUN composer install --prefer-dist

# Add Schedule for automatic updates
RUN echo '30 1 * * * root /strava/cron.sh' >> /etc/cron.d/strava
RUN crontab -u root /etc/cron.d/strava

ADD --chmod=u+x docker/cron.sh cron.sh
RUN dos2unix cron.sh

ADD --chmod=u+x bin/console bin/console
RUN dos2unix bin/console

ADD --chmod=u+x docker/docker-entrypoint.d /docker-entrypoint.d
ADD --chmod=u+x docker/docker-entrypoint.sh /usr/local/bin/
RUN dos2unix /usr/local/bin/docker-entrypoint.sh
RUN dos2unix /docker-entrypoint.d/*

# webserver config
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
RUN dos2unix /etc/nginx/conf.d/default.conf

ENTRYPOINT [ "docker-entrypoint.sh" ]
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]