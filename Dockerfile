FROM php:7.4-fpm-alpine3.14
RUN apk update && apk add --no-cache \
    $PHPIZE_DEPS \
    freetype-dev \
    libpng-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    icu-dev \
    libzip-dev \
    zlib-dev \
    composer \
    freetype \
    libpng \
    libjpeg-turbo 
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
RUN docker-php-ext-configure intl
RUN docker-php-ext-install mysqli intl pdo pdo_mysql zip -j$(nproc) gd
RUN apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

