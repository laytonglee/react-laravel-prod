# Base image with PHP 8.2 CLI
FROM php:8.2-cli

# Set working directory
WORKDIR /var/www

# Install system dependencies, PHP extensions, and Node.js (LTS)
RUN apt-get update && apt-get install -y \
    unzip git curl zip gnupg libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . .

# Install dependencies & build assets
RUN composer install --no-dev --optimize-autoloader \
    && npm install \
    && npm run build

# Expose port
EXPOSE 8000

# Run migrations and start server
CMD php artisan serve --host=0.0.0.0 --port=8000

