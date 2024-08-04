# Use the official PHP 8.3 FPM image based on Alpine Linux
FROM php:8.3-fpm-alpine

# Install PHP extensions
RUN apk add --no-cache \
    libzip-dev \
    libxml2-dev \
    mysql-client \
    curl \
    bash \
    && docker-php-ext-install zip xml mysqli

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Optional Xdebug installation
ARG XDEBUG_ENABLED=false
RUN if [ "$XDEBUG_ENABLED" = "true" ]; then \
      pecl install xdebug && \
      docker-php-ext-enable xdebug; \
    fi

# Copy custom PHP configuration
COPY php.ini /usr/local/etc/php/

# Set the working directory
WORKDIR /var/www/html

# Expose port PHP-FPM
EXPOSE 9000

# Expose port MySQL
EXPOSE 3306

# Start PHP-FPM
CMD ["php-fpm"]
