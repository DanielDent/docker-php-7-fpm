FROM php:7.0-fpm
RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libcurl4-nss-dev \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install curl \
    && docker-php-ext-install mysqli \
    && cd /tmp \
    && curl -L 'https://github.com/EasyFreeHost/pecl-memcache/archive/81b1267413662dfc276f4530122cd1e7aba5c1fc.tar.gz' | tar xz \
    && cd pecl-memcache-81b1267413662dfc276f4530122cd1e7aba5c1fc \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -Rf pecl-memcache-81b1267413662dfc276f4530122cd1e7aba5c1fc \
    && docker-php-ext-enable memcache
WORKDIR /var/www/html
CMD ["/usr/local/sbin/php-fpm", "--nodaemonize"]
