<h1 align="center">DelphinX :dolphin:</h1>

<p align="center">
  <img src="https://img.shields.io/badge/author-kuzuru-blue" alt="author: kuzuru">
  <img src="https://img.shields.io/npm/l/apache" alt="license: MIT">
  <img src="https://img.shields.io/badge/version-1.1.8-informational" alt="version: 1.0.0">
  <img src="https://img.shields.io/github/issues/kuzuru/delphinx" alt="issues">
 </p>
 
***

## Description
:sparkles: DelphinX is ready-to-use package that allows you to automate the process of deploying a ready-made application based on: `Docker`, `Laravel`, `PostgreSQL` and `Nginx`

## Installation
1. If you don't have **Docker** and **Docker-Compose** you should [install it](https://docs.docker.com/compose/install/)
2. If you don't have **git** use following commands: `sudo apt-get update` and `sudo apt-get install git`
3. Use `git clone https://github.com/kuzuru/delphinx.git` to copy all files from this repo

## Usage
1. Building all services via `docker-compose build`
2. Make sure it's working `docker-compose up -d` ( **-d** flag telling docker to run containers in the background )
3. Using `docker ps` find **php-fpm CONTAINER ID**
4. Finally, using `docker exec -it <container_id> php artisan migrate` migrate all tables to your database