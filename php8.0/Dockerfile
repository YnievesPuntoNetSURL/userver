# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.16

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.16, PHP 8.0 FPM with Nginx 1.22, Composer, NodeJS 16.20, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL, OpCache"

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
  php8 \
  php8-bcmath \
  php8-calendar \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-exif \
  php8-fileinfo \
  php8-fpm \
  php8-ftp \
  php8-gd \
  php8-iconv \
  php8-intl \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-pcntl \
  php8-pdo_mysql \
  php8-pdo_pgsql \
  php8-pdo_sqlite \
  php8-pecl-imagick \
  php8-phar \
  php8-posix \
  php8-session \
  php8-simplexml \
  php8-soap \
  php8-sockets \
  php8-sodium \
  php8-sqlite3 \
  php8-tokenizer \
  php8-xml \
  php8-xmlreader \
  php8-xmlwriter \
  php8-zip \
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
RUN ln -s /usr/bin/phar8 /usr/bin/phar && \
    ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm
COPY config/php/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php8/conf.d/custom.ini

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
    /var/log/exim /var/log/php8 /var/log/supervisor

# Let supervisord start exim, nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Add application
COPY --chown=app src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
