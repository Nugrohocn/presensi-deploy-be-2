FROM dunglas/frankenphp:php8.2-bookworm

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

RUN mkdir -p storage/framework/{sessions,views,cache,testing} storage/logs bootstrap/cache \
    && chmod -R a+rw storage

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
