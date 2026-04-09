FROM dunglas/frankenphp:php8.2

# 1. Install ekstensi PHP yang dibutuhkan (Sudah benar)
RUN install-php-extensions \
    gd \
    pdo_pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    zip

# 2. TAMBAHKAN BARIS INI untuk mengambil binary composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

# 3. Sekarang perintah ini akan berjalan sukses
RUN composer install --no-dev --optimize-autoloader

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
