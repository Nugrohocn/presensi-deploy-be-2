FROM dunglas/frankenphp:php8.2

# 1. Install ekstensi PHP yang dibutuhkan
RUN install-php-extensions \
    gd \
    pdo_pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    zip

# 2. Ambil binary composer terbaru
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 3. Set Working Directory
WORKDIR /app

# 4. Copy seluruh file project ke dalam container [cite: 5]
COPY . .

# 5. Install dependencies Laravel [cite: 5]
RUN composer install --optimize-autoloader --no-dev

# 6. Set izin (permissions) folder storage dan cache agar Laravel bisa menulis log/file
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# 7. Konfigurasi Port dan Jalankan Server
# Kita menggunakan variabel $PORT yang disediakan otomatis oleh Railway.
# Perintah ini akan menjalankan migrasi, seeding, lalu menyalakan server.
CMD php artisan migrate --force && \
    php artisan db:seed --force && \
    frankenphp php-server --listen :$PORT
