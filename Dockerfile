FROM composer:latest AS composer
FROM dunglas/frankenphp:php8.2-bookworm

# Copy composer binary dari official composer image
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libxml2-dev \
    libpq-dev \
    libonig-dev \
    && docker-php-ext-install zip gd pdo_pgsql \
    && apt-get clean

COPY . /app

WORKDIR /app

RUN composer install --optimize-autoloader --no-scripts --no-interaction

# Patch ServeCommand to cast $port to int before arithmetic, preventing
# "Unsupported operand types: string + int" when PORT env var is a string.
RUN sed -i 's/return \$port + \$this->portOffset;/return (int)\$port + \$this->portOffset;/' \
    vendor/laravel/framework/src/Illuminate/Foundation/Console/ServeCommand.php

RUN mkdir -p storage/framework/{sessions,views,cache,testing} storage/logs bootstrap/cache \
    && chmod -R a+rw storage

EXPOSE 8000

# Use shell form so $PORT is expanded at runtime, passing it explicitly as
# the --port argument to avoid Laravel reading it as a raw env string.
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
