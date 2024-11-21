# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.15

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.15, PHP 7.4 FPM with Nginx 1.20, Composer, NodeJS 16.20, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

# Setup document root
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN apk add --no-cache \
  busybox-suid \
  curl \
  exim \
  icu-data \
  git \
  nginx \
  nginx-mod-http-geoip \
  nginx-mod-http-brotli \
  nginx-mod-http-image-filter \
  nginx-mod-http-xslt-filter \
  nginx-mod-stream-geoip \
  nodejs \
  npm \
  mysql-client \
  php7 \
  php7-bcmath \
  php7-calendar \
  php7-ctype \
  php7-curl \
  php7-dom \
  php7-exif \
  php7-fileinfo \
  php7-ftp \
  php7-fpm \
  php7-gd \
  php7-iconv \
  php7-intl \
  php7-json \
  php7-mbstring \
  php7-mysqli \
  php7-opcache \
  php7-openssl \
  php7-pcntl \
  php7-pdo_mysql \
  php7-pdo_pgsql \
  php7-pdo_sqlite \
  php7-pecl-imagick \
  php7-phar \
  php7-posix \
  php7-session \
  php7-simplexml \
  php7-soap \
  php7-sodium \
  php7-sockets \
  php7-sqlite3 \
  php7-tokenizer \
  php7-xml \
  php7-xmlreader \
  php7-xmlwriter \
  php7-zip \
  supervisor \
  tzdata \
  yarn \
  libssl3 \
  libcrypto3

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure nginx - http
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
# Configure nginx - default server
COPY config/nginx/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
RUN ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm
COPY config/php/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php7/conf.d/custom.ini

# Configure Exim
COPY config/exim/exim.conf /etc/exim/exim.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add app user for run apps
RUN addgroup -g 1000 app && \
  adduser -u 1000 -G app -h /home/app -s /bin/sh -D app

# Create some new directories
RUN mkdir /var/www/html /run /var/lib/nginx /var/log/nginx /var/cache/nginx /var/log/exim

# Make sure files/folders needed by the processes are accessable when they run under the app user
RUN chown -R app:app /var/www/html /run /var/lib/nginx /var/log/nginx /var/cache/nginx /var/log/exim

# Switch to use a non-root user from here on
USER app

# Add application
COPY --chown=app src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
