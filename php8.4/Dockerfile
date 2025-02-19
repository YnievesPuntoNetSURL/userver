# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.21

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.21, PHP 8.4 FPM with Nginx 1.26, Composer, NodeJS 20.15, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

# Setup document root
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN apk add --no-cache \
  busybox-suid \
  curl \
  exim \
  icu-data-full \
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
  php84 \
  php84-bcmath \
  php84-calendar \
  php84-ctype \
  php84-curl \
  php84-dom \
  php84-exif \
  php84-fileinfo \
  php84-ftp \
  php84-fpm \
  php84-gd \
  php84-iconv \
  php84-intl \
  php84-mbstring \
  php84-mysqli \
  php84-opcache \
  php84-openssl \
  php84-pcntl \
  php84-pdo_mysql \
  php84-pdo_pgsql \
  php84-pdo_sqlite \
  php84-pecl-imagick \
  php84-phar \
  php84-posix \
  php84-session \
  php84-simplexml \
  php84-soap \
  php84-sodium \
  php84-sockets \
  php84-sqlite3 \
  php84-tokenizer \
  php84-xml \
  php84-xmlreader \
  php84-xmlwriter \
  php84-zip \
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
RUN ln -s /usr/sbin/php-fpm83 /usr/sbin/php-fpm
COPY config/php/fpm-pool.conf /etc/php84/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php84/conf.d/custom.ini

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
RUN chown -R app:app /var/www/html /var/log/php-fpm /run /var/lib/nginx /var/log/nginx /var/cache/nginx /var/log/exim /var/log/php84 /var/log/supervisor

# Let supervisord start exim, nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Add application
COPY --chown=app src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
