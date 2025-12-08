# YnievesPuntoNet µServer (PHP-FPM, Nginx, Node,... and more on Alpine Linux)

[![Docker Pulls](https://img.shields.io/docker/pulls/ynievesdotnet/userver.svg)](https://hub.docker.com/r/ynievesdotnet/userver/)
[![Docker Stars](https://img.shields.io/docker/stars/ynievesdotnet/userver.svg)](https://hub.docker.com/r/ynievesdotnet/userver/)
[![Docker Automated build](https://img.shields.io/docker/automated/ynievesdotnet/userver.svg)](https://hub.docker.com/r/ynievesdotnet/userver/)
![µServer 1.0.0](https://img.shields.io/badge/µServer-1.0.0-brightgreen.svg)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

µServer PHP-FPM & Nginx container image for Docker, built on [Alpine Linux](https://www.alpinelinux.org/).

Repository: <https://github.com/ynievespuntonetsurl/userver>

* Built on the lightweight and secure Alpine Linux distribution.
* Multi-platform support, including AMD4, ARMv6, ARMv7, and ARM64.
* Powered for enhanced performance, lower CPU usage, and reduced memory footprint.
* Optimized to handle up to 500 concurrent users, ensuring high scalability.
* Utilizes PHP-FPM's `on-demand` process manager, dynamically allocating resources only when traffic is present.
* Nginx server with built-in support for Brotli compression and other advanced features.
* All service logs are redirected to the Docker container's output, easily accessible with `docker logs -f <container name>`.
* Follows the KISS principle (Keep It Simple, Stupid) for easy understanding and customization.
* Ideal for use with Kubernetes or alternative container orchestration platforms (e.g., k8s, k3s, ...).

## Goal of this project

This app server container image is optimized for production environments. It has been fine-tuned and configured to deliver optimal performance and reliability, making it well-suited for running your applications in a production setting. The image incorporates various optimizations and best practices to ensure efficient resource usage, reduced CPU usage, and minimal memory footprint. By utilizing PHP, it takes advantage of the latest improvements in PHP's performance. The inclusion of Nginx with Brotli compression support further enhances the server's capabilities. Additionally, the image follows the principle of keeping things simple (KISS) to facilitate easy customization and adaptation to meet the specific needs of your production environment. It is an ideal choice for deploying your applications in production, whether in a Kubernetes or alternative environment (such as k8s, k3s, etc.).

## Usage

Start the Docker container:

    docker run -p 8000:80 ynievesdotnet/userver:latest

See the PHP info on <http://localhost:8000>, or the static html page on <http://localhost:8000/test.html>

Or mount your own code to be served by PHP-FPM & Nginx

    docker run -p 8000:80 -v ~/php_app_code:/var/www/html ynievesdotnet/userver:latest

## Tags

| Tags          | Alpine Linux | PHP | Node  | Nginx |
|:--------------|:------------:|:---:|:-----:|:-----:|
|php8.5(latest) |     3.23     | 8.5 | 24.11 | 1.28  |
|php8.4         |     3.23     | 8.4 | 24.11 | 1.28  |
|php8.3         |     3.23     | 8.3 | 24.11 | 1.28  |
|php8.2         |     3.22     | 8.2 | 22.16 | 1.28  |
|php8.1(d)      |     3.19     | 8.1 | 20.15 | 1.24  |
|php8.0(d)      |     3.16     | 8.0 | 16.20 | 1.22  |
|php7.4(d)      |     3.15     | 7.4 | 16.20 | 1.20  |

(d) -> Deprecated, not recomendable for production

## Configuration

In [config/](config/) you'll find the default configuration files for Nginx, PHP and PHP-FPM.
If you want to extend or customize that you can do so by mounting a configuration file in the correct folder;

Nginx configuration:

    docker run -v "./nginx-server.conf:/etc/nginx/conf.d/server.conf" ynievesdotnet/userver:latest

PHP configuration:

    docker run -v "./php-setting.ini:/etc/php81/conf.d/settings.ini" ynievesdotnet/userver:latest

PHP-FPM configuration:

    docker run -v "./php-fpm-settings.conf:/etc/php8/php-fpm.d/server.conf" ynievesdotnet/userver:latest

## How to use with Docker Composer

You can use this image with Docker Composer, just create a `docker-compose.yml` file like this:

    name: 'Name APP'

    services:
        name_app:
            container_name: name_app
            image: ynievesdotnet/userver:latest
            restart: unless-stopped
            expose:
            - "80"
            volumes:
            - ./src:/var/www/html

This environment not require any configuration by default, just run the container and the app will be available in port 80.

## Resume

Feel free to use and make issue to better work.

Thanks.

YnievesPuntoNet S.U.R.L
