# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.18

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.18, PHP 8.2 FPM with Nginx 1.24, Composer, NodeJS, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

# Setup document root
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN apk add --no-cache \
  curl \
  icu-data-full \
  nginx \
  nginx-mod-http-geoip \
  nginx-mod-http-brotli \
  nginx-mod-http-image-filter \
  nginx-mod-http-xslt-filter \
  nginx-mod-stream-geoip \
  nodejs \
  npm \
  php82 \
  php82-bcmath \
  php82-ctype \
  php82-curl \
  php82-dom \
  php82-exif \
  php82-fpm \
  php82-gd \
  php82-iconv \
  php82-intl \
  php82-mbstring \
  php82-mysqli \
  php82-pdo_mysql \
  php82-pdo_pgsql \
  php82-opcache \
  php82-openssl \
  php82-pcntl \
  php82-pecl-imagick \
  php82-fileinfo \
  php82-phar \
  php82-session \
  php82-simplexml \
  php82-tokenizer \
  php82-xml \
  php82-xmlreader \
  php82-xmlwriter \
  php82-zip \
  supervisor \
  yarn \
  libssl3 \
  libcrypto3

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure nginx - http
COPY config/nginx.conf /etc/nginx/nginx.conf
# Configure nginx - default server
COPY config/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
RUN ln -s /usr/bin/php82 /usr/bin/php
COPY config/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY config/php.ini /etc/php82/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create somw cache directory
RUN mkdir -p /var/cache/nginx /.composer /.npm

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx /var/cache/nginx /.composer /.npm

# Switch to use a non-root user from here on
USER nobody

# Add application
COPY --chown=nobody src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
