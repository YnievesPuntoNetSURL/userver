# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.18

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.18, PHP 8.1 FPM with Nginx 1.22, Composer, NodeJS, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

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
  php81 \
  php81-bcmath \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-exif \
  php81-fpm \
  php81-gd \
  php81-intl \
  php81-mbstring \
  php81-mysqli \
  php81-pdo_mysql \
  php81-pdo_pgsql \
  php81-opcache \
  php81-openssl \
  php81-pcntl \
  php81-pecl-imagick \
  php81-phar \
  php81-session \
  php81-xml \
  php81-xmlreader \
  php81-zip \
  supervisor \
  yarn

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure nginx - http
COPY config/nginx.conf /etc/nginx/nginx.conf
# Configure nginx - default server
COPY config/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php.ini /etc/php81/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create Nginx cache directory
RUN mkdir -p /var/cache/nginx

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx /var/cache/nginx

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
