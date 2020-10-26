FROM php:7.4-fpm

#=============================================
# Setup Section
#=============================================

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

LABEL maintainer="Kiselev Artem <kuzuru.dev@gmail.com>"

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www/
WORKDIR "/var/www/"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev \
#=============================================
# Installing Requirements Section
#=============================================

RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    apt-get install -yqq \
    apt-utils \
    libpq-dev \
    vim \
    wget \
    libzip-dev \
    unzip \
    build-essential \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    libzip-dev zip unzip && \
    docker-php-ext-configure zip; \
    # Install the zip extension
    docker-php-ext-install zip && \
    php -m | grep -q 'zip'

# Install the pgsql extension
RUN docker-php-ext-install pdo_pgsql pgsql

# Dependencies for docker-php-ext-install
RUN apt -yqq update
RUN apt -yqq install libxml2-dev
# Install PHP Redis Extension
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
# Install PHP Swoole Extension
RUN pecl install swoole \
    && docker-php-ext-enable swoole \
    && php -m | grep -q 'swoole'

# Install git
RUN apt-get update \
    && apt-get -y --no-install-recommends install git \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
# Install the exif extension
RUN docker-php-ext-install exif

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# Install the bcmath extension
RUN docker-php-ext-install bcmath

# Install extensions
RUN docker-php-ext-install pdo pgsql pdo_pgsql zip exif pcntl gd
# Install the opcache extension
RUN docker-php-ext-install opcache

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo pdo_pgsql
# Copy opcache configration
COPY ./php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Install the intl extension ( Character Encoding Support ) & Requirements for it
RUN apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www
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
COPY --chown=www:www . /var/www
COPY --chown=www-data:www-data . /var/www

# Change current user to www
USER www
# Change current user to www-data
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
# Expose 9000 & 1215 ports
EXPOSE 9000 1215

# Start php-fpm
CMD ["php-fpm"]

# Start swoole http server
CMD ["php", "artisan", "swoole:http", "start"]

