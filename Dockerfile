FROM php:8.1 as php

RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev
# RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

WORKDIR /var/www
COPY . .

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

RUN composer install --no-progress --no-interaction
RUN composer update --no-scripts



ENV PORT=8000


RUN php artisan key:generate 
RUN php artisan cache:clear 
RUN php artisan config:clear 
RUN php artisan route:clear 

CMD [ "php","artisan", "serve", "--host=0.0.0.0", "--port=8000" ]

# ==============================================================================
#  node
# FROM node:14-alpine as node

# WORKDIR /var/www
# COPY . .

# RUN npm install --global cross-env
# RUN npm install

# VOLUME /var/www/node_modules
