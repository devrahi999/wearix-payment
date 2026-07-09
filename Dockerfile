FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libmagickwand-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        mbstring \
        gd \
        zip \
        intl \
        bcmath \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && a2enmod rewrite headers expires \
    && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html/

RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' \
    /etc/apache2/apache2.conf \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && chmod -R 775 /var/www/html/pp-media \
    && chmod -R 775 /var/www/html/pp-content

EXPOSE 80

CMD ["apache2-foreground"]
