<h1 align="center">DelphinX :dolphin:</h1>

<p align="center">
  <img src="https://img.shields.io/badge/author-kuzuru-blue" alt="author: kuzuru">
  <img src="https://img.shields.io/npm/l/apache" alt="license: MIT">
  <img src="https://img.shields.io/badge/version-2.0.4-informational" alt="version: 2.0.0">
  <img src="https://img.shields.io/github/issues/kuzuru/delphinx" alt="issues">
 </p>
 
***

## Description
:sparkles: DelphinX is **ready-to-use** package that allows you to speed up the process of creating your laravel application. This package is based on `Docker`. After installing DelphinX, you'll have ready-to-use `Laravel`-`PostgreSQL`-`Nginx` application with in-memory key-value database `Redis` ( It's optional, don't worry ). DlephinX will accelerate your laravel applications to supersonic speed by the power of an asynchronous framework called `Swoole`

## Installation
1. If you don't have **Docker** and **Docker-Compose** you should **[install it](https://docs.docker.com/compose/install/)**
2. If you don't have **Composer** you should **[install it](https://getcomposer.org/)**
3. If you don't have **[git](https://git-scm.com/)** use following commands: `sudo apt-get update` and `sudo apt-get install git`
4. Create new laravel application via `laravel new <your_app_name>`
5. Using `git clone https://github.com/kuzuru/delphinx.git` copy all files from this repo to your app
6. Extract all files from folder called "delphinx" into main laravel's application folder `( Overwrite all files )`
7. Delete empty delphinx's folder :smile:
8. Run into your console / shell: `php delphinSetup`
9. Open `.env.example` and change these things:
    * `APP_NAME`
    * `APP_URL`
    * `DB_PASSWORD`
    * `DB_DATABASE` and `DB_USERNAME` - **[!]** Make these variables the same **[!]**
    * `CACHE_DRIVER` and `SESSION_DRIVER` ( Optional: `redis` ( Recommended ) or `file` )
10. Rename `.env.example` to `.env`
11. Generate app key using `php artisan key:generate`
12. Install and compile node modules:
    * If you're in dev environment: `npm install && npm run dev`
    * If you're in production environment: `npm install && npm run prod`

## Usage
1. Build all services via `docker-compose build`
2. Startup all containers: `docker-compose up -d` ( **-d** flag telling docker to run containers in the background )
3. Using `docker exec -it php-fpm php artisan migrate` migrate all tables to your database
4. If you're in a production environment run `php delphinProductionDeploy`