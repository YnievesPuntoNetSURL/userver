# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.21

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.21, PHP 8.2 FPM with Nginx 1.26, Composer, NodeJS 20.15, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

# Setup document root
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN apk add --no-cache \
  busybox-suid \
  curl \
  exim \
  git \
  icu-data-full \
  libcrypto3 \
  libssl3 \
  mysql-client \
  nginx \
  nginx-mod-http-brotli \
  nginx-mod-http-geoip \
  nginx-mod-http-image-filter \
  nginx-mod-http-xslt-filter \
  nginx-mod-stream-geoip \
  nodejs \
  npm \
  php82 \
  php82-bcmath \
  php82-calendar \
  php82-ctype \
  php82-curl \
  php82-dom \
  php82-exif \
  php82-fileinfo \
  php82-fpm \
  php82-ftp \
  php82-gd \
  php82-iconv \
  php82-intl \
  php82-mbstring \
  php82-mysqli \
  php82-opcache \
  php82-openssl \
  php82-pcntl \
  php82-pdo_mysql \
  php82-pdo_pgsql \
  php82-pdo_sqlite \
  php82-pecl-imagick \
  php82-phar \
  php82-posix \
  php82-session \
  php82-simplexml \
  php82-soap \
  php82-sockets \
  php82-sodium \
  php82-sqlite3 \
  php82-tokenizer \
  php82-xml \
  php82-xmlreader \
  php82-xmlwriter \
  php82-zip \
  supervisor \
  tzdata \
  yarn

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure nginx - http
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure nginx - default server
COPY config/nginx/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
RUN ln -s /usr/bin/php82 /usr/bin/php
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm
COPY config/php/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php82/conf.d/custom.ini

# Configure Exim
COPY config/exim/exim.conf /etc/exim/exim.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisord.conf

# Add app user for run apps
RUN addgroup -g 1000 app && \
  adduser -u 1000 -G app -h /home/app -s /bin/sh -D app

# Allow app user to run crontabs
RUN echo app >> /etc/cron.allow

# Create some new directories
RUN mkdir -p /var/www/html /run /var/log/php-fpm /var/lib/nginx/logs /var/log/nginx /var/cache/nginx /var/log/exim /var/log/supervisor

# Make sure files/folders needed by the processes are accessable when they run under the app user
RUN chown -R app:app /var/www/html /var/log/php-fpm /run /var/lib/nginx /var/log/nginx /var/cache/nginx /var/log/exim /var/log/php82 /var/log/supervisor

# Let supervisord start exim, nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Add application
COPY --chown=app src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
