# YnievesPuntoNet µServer (PHP-FPM 7.4, Nginx 1.20 on Alpine Linux 3.15)

[![Docker Pulls](https://img.shields.io/docker/pulls/ynievesdotnet/userver.svg)](https://hub.docker.com/r/ynievesdotnet/userver/)
[![Docker Stars](https://img.shields.io/docker/stars/ynievesdotnet/userver.svg)](https://hub.docker.com/r/ynievesdotnet/userver/)
[![Docker Automated build](https://img.shields.io/docker/automated/ynievesdotnet/userver.svg)](https://hub.docker.com/r/ynievesdotnet/userver/)

![µServer 1.0.0](https://img.shields.io/badge/µServer-1.0.0-brightgreen.svg)
![alpine 3.15](https://img.shields.io/badge/alpine-3.15-brightgreen.svg)
![nginx 1.20](https://img.shields.io/badge/nginx-1.20-brightgreen.svg)
![php 7.4](https://img.shields.io/badge/php-7.4-brightgreen.svg)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

µServer PHP-FPM 7.4 & Nginx 1.20 container image for Docker, built on [Alpine Linux](https://www.alpinelinux.org/).

Repository: <https://github.com/ynievespuntonetsurl/userver>

* Built on the lightweight and secure Alpine Linux distribution.
* Multi-platform support, including AMD4, ARMv6, ARMv7, and ARM64.
* Powered by PHP 7.4 for enhanced performance, lower CPU usage, and reduced memory footprint.
* Optimized to handle up to 500 concurrent users, ensuring high scalability.
* Utilizes PHP-FPM's `on-demand` process manager, dynamically allocating resources only when traffic is present.
* Nginx server with built-in support for Brotli compression and other advanced features.
* All service logs are redirected to the Docker container's output, easily accessible with `docker logs -f <container name>`.
* Follows the KISS principle (Keep It Simple, Stupid) for easy understanding and customization.
* Ideal for use with Kubernetes or alternative container orchestration platforms (e.g., k8s, k3s, ...).

## Goal of this project

This app server container image is optimized for production environments. It has been fine-tuned and configured to deliver optimal performance and reliability, making it well-suited for running your applications in a production setting. The image incorporates various optimizations and best practices to ensure efficient resource usage, reduced CPU usage, and minimal memory footprint. By utilizing PHP 7.4, it takes advantage of the stable improvements in PHP's performance. The inclusion of Nginx with Brotli compression support further enhances the server's capabilities. Additionally, the image follows the principle of keeping things simple (KISS) to facilitate easy customization and adaptation to meet the specific needs of your production environment. It is an ideal choice for deploying your applications in production, whether in a Kubernetes or alternative environment (such as k8s, k3s, etc.).

## Usage

Start the Docker container:

    docker run -p 8000:80 ynievesdotnet/userver:php7

See the PHP info on <http://localhost:8000>, or the static html page on <http://localhost:8000/test.html>

Or mount your own code to be served by PHP-FPM & Nginx

    docker run -p 8000:80 -v ~/php_app_code:/var/www/html ynievesdotnet/userver:php7

## Configuration

In [config/](config/) you'll find the default configuration files for Nginx, PHP and PHP-FPM.
If you want to extend or customize that you can do so by mounting a configuration file in the correct folder;

Nginx configuration:

    docker run -v "./nginx-server.conf:/etc/nginx/conf.d/server.conf" ynievesdotnet/userver:php7

PHP configuration:

    docker run -v "./php-setting.ini:/etc/php81/conf.d/settings.ini" ynievesdotnet/userver:php7

PHP-FPM configuration:

    docker run -v "./php-fpm-settings.conf:/etc/php8/php-fpm.d/server.conf" ynievesdotnet/userver:php7

## How to use with Docker Composer

You can use this image with Docker Composer, just create a `docker-compose.yml` file like this:

    version: '3.1'

    services:
        name_app:
            container_name: name_app
            image: ynievesdotnet/userver:php7
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
