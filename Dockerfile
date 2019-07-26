FROM php:7.3.7-fpm AS setup
MAINTAINER Valentin Prugnaud <valentin@speakbox.ca>

# Install nginx and php dependencies
RUN apt-get update \
    # Install packages
    && apt-get install -y --no-install-recommends build-essential supervisor nginx curl git libzip-dev libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev  \
    # Install PHP extensions
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-webp-dir=/usr/include/ \
    && docker-php-ext-install gd bcmath ctype json mbstring pdo_mysql zip \
    && docker-php-ext-enable opcache \
    # Clean up
    && apt-get remove -y --purge software-properties-common \
    && apt-get autoremove -y  \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/pear/ /var/tmp/* /tmp/*

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install prestissimo for faster composer installs
# https://github.com/hirak/prestissimo
RUN composer global require hirak/prestissimo

# Redirect log to stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /dev/stderr /var/log/fpm-php.www.log

RUN chown www-data:www-data /var/www

# COPY nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/sites-enabled/default

# Copy PHP-FPM config
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /etc/supervisor

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80
