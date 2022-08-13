FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid
ARG home

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libxslt-dev \
    procps \
    zip \
    unzip \
    net-tools \
    telnet \
    vim

# Set memory_limit
#RUN echo "php_admin_value[memory_limit] = 2G" >> /usr/local/etc/php-fpm.d/www.conf
COPY etc/php.ini /usr/local/etc/php/conf.d/php.override.ini

# Install PHP extensions
RUN apt-get update && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip soap intl xsl

# install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install PDF generator
RUN apt-get install -y wkhtmltopdf
RUN [ -f /usr/bin/wkhtmltopdf ] && ln -s /usr/bin/wkhtmltopdf /usr/local/bin/

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Install node
RUN apt-get update -yq \
        && apt-get install curl gnupg -yq \
        && curl -sL https://deb.nodesource.com/setup_14.x | bash \
        && apt-get install nodejs -yq

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d $home $user

# Set working directory
WORKDIR /var/www

USER $user

#CMD php artisan serve
#CMD npm run serve

EXPOSE 9000
CMD ["php-fpm"]
