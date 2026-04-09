FROM dunglas/frankenphp:php8.2

RUN install-php-extensions \
    gd \
    pdo_pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    zip

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
