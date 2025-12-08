# µServer, for deploy php applications for YnievesPuntoNet SURL
ARG ALPINE_VERSION=3.23

# Base Image
FROM alpine:${ALPINE_VERSION}

# Labels
LABEL maintainer="YnievesPuntoNet S.U.R.L. <ynieves@ynieves.net>"
LABEL version="1.0.0"
LABEL description="Alpine 3.23, PHP 8.5 FPM with Nginx 1.28, Composer, NodeJS 24, Yarn, GD, Imagick, Intl, Zip, PCNTL, Bcmath, Exif, PDO MySQL and PgSQL"

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
  php85 \
  php85-bcmath \
  php85-calendar \
  php85-ctype \
  php85-curl \
  php85-dom \
  php85-exif \
  php85-fileinfo \
  php85-fpm \
  php85-ftp \
  php85-gd \
  php85-iconv \
  php85-intl \
  php85-mbstring \
  php85-mysqli \
  php85-openssl \
  php85-pcntl \
  php85-pdo_mysql \
  php85-pdo_pgsql \
  php85-pdo_sqlite \
  php85-pecl-imagick \
  php85-phar \
  php85-posix \
  php85-session \
  php85-simplexml \
  php85-soap \
  php85-sockets \
  php85-sodium \
  php85-sqlite3 \
  php85-tokenizer \
  php85-xml \
  php85-xmlreader \
  php85-xmlwriter \
  php85-zip \
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
RUN ln -s /usr/bin/php85 /usr/bin/php && \
    ln -s /usr/bin/phar85 /usr/bin/phar && \
    ln -s /usr/sbin/php-fpm85 /usr/sbin/php-fpm
COPY config/php/fpm-pool.conf /etc/php85/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php85/conf.d/custom.ini

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
    /var/log/exim /var/log/php85 /var/log/supervisor

# Let supervisord start exim, nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Add application
COPY --chown=app src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping
