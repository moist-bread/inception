# INCEPTION

## **📖 CHAPTERS**

- [Services provided by the Stack](#services-provided-by-the-stack) 💭
- [Usage](#usage) 🆙
- [WordPress Functionality](#wordpress-functionality) 👔
- [Credentials](#credentials) 🔐
- [Health Check](#health-check) 👋

## **SERVICES PROVIDED BY THE STACK**

This Stack is composed of:

- `NGINX` - HTTP web server, reverse proxy;
- `WordPress + pfp-fpm` - Blog Hosting Service with dynamic content;
- `MariaDB` - Relational database to store the WordPress content.

For a deep dive on each of the Services check the [Resources Chapter](README.md#resources) 📚 of the README.md file .

## **USAGE**

This project has a few dependencies so for ease of use there's a script to install them: 

```bash
./pre_requirements.sh
```

The script installs: **curl**, **make** and **docker**

To run `Inception` simply build and start it with `make` :

```bash
make
```

To start and stop: `make down`, `make stop`, `make start`, `make restart`.

## WORDPRESS FUNCTIONALITY

- **Website**: https://rduro-pe.42.fr
- **Administration Panel**: https://rduro-pe.42.fr/wp-admin

## CREDENTIALS

After doing `make` or `make setup` the following files are created:

- `.env` :  you can change values directly in this file;
- `/secrets/*` : inside the secrets directory there is a file for each sensitive information, in specific passwords, needed to start this service. they can be changed in each file.

## HEALTH CHECK

```bash
make healthcheck
```