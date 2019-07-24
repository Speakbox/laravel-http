FROM php:7.3.7-fpm AS setup
MAINTAINER Valentin Prugnaud <valentin@speakbox.ca>

# Install nginx and php dependencies
RUN apt-get update \
    # nginx
    && apt-get install -y --no-install-recommends nginx \
    # gd
    && apt-get install -y --no-install-recommends curl git libzip-dev libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev  \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-webp-dir=/usr/include/ \
    && docker-php-ext-install gd \
    # bcmath
    && docker-php-ext-install bcmath \
    # ctype
    && docker-php-ext-install ctype \
    # json
    && docker-php-ext-install json \
    # mbstring
    && docker-php-ext-install mbstring \
    # pdo_mysql
    && docker-php-ext-install pdo_mysql \
    # opcache
    && docker-php-ext-enable opcache \
    # zip
    && docker-php-ext-install zip \
    # clean up
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear/ \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer global require hirak/prestissimo

# Redirect log to stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# COPY nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/sites-available/default

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 80
