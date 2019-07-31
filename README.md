# Laravel HTTP

Creates a Laravel Docker image with php-fpm & nginx, optimized for HTTP.

[speakbox/laravel-http](https://hub.docker.com/r/speakbox/laravel-http)

## Packages

- php-fpm 7.3
- nginx
- curl
- git
- supervisor
- composer

## Ports

- 80

## Makefile

```bash
// Build docker image
$ make build

// Run docker image
$ make run

// Push docker image
$ make push
```

## Login to Docker Hub from CLI

Simply run and follow the steps:

```bash
$ docker login
```
