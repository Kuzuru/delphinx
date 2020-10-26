FROM php:7.4-fpm

#=============================================
# Setup Section
#=============================================

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

LABEL maintainer="Kiselev Artem <raiter.man5@gmail.com>"

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

#=============================================
# Installing Requirements Section
#=============================================

RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    apt-get install -yqq \
    apt-utils \
    libpq-dev \
    libzip-dev zip unzip && \
    docker-php-ext-configure zip; \
    # Install the zip extension
    docker-php-ext-install zip && \
    php -m | grep -q 'zip'

# Install the pgsql extension
RUN docker-php-ext-install pdo_pgsql pgsql

# Install PHP Redis Extension
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Install PHP Swoole Extension
RUN pecl install swoole \
    && docker-php-ext-enable swoole \
    && php -m | grep -q 'swoole'

# Install the exif extension
RUN docker-php-ext-install exif

# Install the bcmath extension
RUN docker-php-ext-install bcmath

# Install the opcache extension
RUN docker-php-ext-install opcache

# Copy opcache configration
COPY ./php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install the intl extension ( Character Encoding Support ) & Requirements for it
RUN apt-get install -y --no-install-recommends zlib1g-dev libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Check PHP version
RUN set -xe; php -v

#=============================================
# Final Section
#=============================================

USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Configure non-root user
RUN groupmod -o -g 1000 www-data \
    && usermod -o -u 1000 -g www-data www-data

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Change current user to www-data
USER www-data

# Expose 9000 & 1215 ports
EXPOSE 9000 1215

# Start swoole http server
CMD ["php", "artisan", "swoole:http", "start"]