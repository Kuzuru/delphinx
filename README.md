<h1 align="center">DelphinX :dolphin:</h1>

<p align="center">
  <img src="https://img.shields.io/badge/author-kuzuru-blue" alt="author: kuzuru">
  <img src="https://img.shields.io/npm/l/apache" alt="license: MIT">
  <img src="https://img.shields.io/badge/version-1.1.12-informational" alt="version: 1.0.0">
  <img src="https://img.shields.io/github/issues/kuzuru/delphinx" alt="issues">
 </p>
 
***

## Description
:sparkles: DelphinX is **ready-to-use** package that allows you to speed up the process of creating your laravel application. This package based on `Docker`. After installing it, you'll have ready-to-use `Laravel`-`PostgreSQL`-`Nginx` application.

## Installation
1. If you don't have **Docker** and **Docker-Compose** you should **[install it](https://docs.docker.com/compose/install/)**
2. If you don't have **[git](https://git-scm.com/)** use following commands: `sudo apt-get update` and `sudo apt-get install git`
3. Create new laravel application via `laravel new <your_app_name>`
4. Using `git clone https://github.com/kuzuru/delphinx.git` copy all files from this repo to your app
5. Extract all files from folder called "delphinx" into main laravel's application folder `( Overwrite all files )`
6. Delete empty delphinx's folder :smile:
7. Open `.env.example` and change these things:
    * `APP_NAME`
    * `APP_URL`
    * `DB_PASSWORD`
    * `DB_DATABASE` and `DB_USERNAME` - **[!]** Make these variables the same **[!]**
8. Rename `.env.example` to `.env`
9. Install and compile node modules using `npm install && npm run dev`
10. Done :)

## Usage
1. Building all services via `docker-compose build`
2. Make sure it's working `docker-compose up -d` ( **-d** flag telling docker to run containers in the background )
3. Using `docker ps` find **php-fpm CONTAINER ID**
4. Generate app key using `docker exec -it <container_id> php artisan key:generate`
5. Finally, using `docker exec -it <container_id> php artisan migrate` migrate all tables to your database