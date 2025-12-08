# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.19

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.19, PHP 8.1 FPM with Nginx 1.24, Composer, NodeJS 20.15, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

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
  php81 \
  php81-bcmath \
  php81-calendar \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-exif \
  php81-fileinfo \
  php81-fpm \
  php81-ftp \
  php81-gd \
  php81-iconv \
  php81-intl \
  php81-mbstring \
  php81-mysqli \
  php81-opcache \
  php81-openssl \
  php81-pcntl \
  php81-pdo_mysql \
  php81-pdo_pgsql \
  php81-pdo_sqlite \
  php81-pecl-imagick \
  php81-phar \
  php81-posix \
  php81-session \
  php81-simplexml \
  php81-soap \
  php81-sockets \
  php81-sodium \
  php81-sqlite3 \
  php81-tokenizer \
  php81-xml \
  php81-xmlreader \
  php81-xmlwriter \
  php81-zip \
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
RUN ln -s /usr/bin/php81 /usr/bin/php && \
    ln -s /usr/bin/phar81 /usr/bin/phar && \
    ln -s /usr/sbin/php-fpm81 /usr/sbin/php-fpm
COPY config/php/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php81/conf.d/custom.ini

# Configure Exim
COPY config/exim/exim.conf /etc/exim/exim.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisord.conf

# Add app user for run apps
RUN addgroup -g 1000 app && \
    adduser -u 1000 -G app -h /home/app -s /bin/sh -D app && \
# Allow app user to run crontabs
    echo app >> /etc/cron.allow && \
# Create some new directories
    mkdir -p /var/www/html /run /var/log/php-fpm \
    /var/lib/nginx/logs /var/log/nginx /var/cache/nginx \
    /var/log/exim /var/log/supervisor && \
# Make sure files/folders needed by the processes are accessable when they run under the app user
    chown -R app:app /var/www/html /var/log/php-fpm \
    /run /var/lib/nginx /var/log/nginx /var/cache/nginx \
    /var/log/exim /var/log/php81 /var/log/supervisor

# Let supervisord start exim, nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Add application
COPY --chown=app src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
