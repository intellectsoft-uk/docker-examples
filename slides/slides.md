class: center, middle

# Docker, what is all about

Intellectsoft LTD

---

# Dockerfile

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install \
        mcrypt \
        bcmath \
        mbstring \
        zip \
        opcache \
        pdo pdo_pgsql

RUN yes | pecl install apcu xdebug-beta \
        && echo "extension=$(find /usr/local/lib/php/extensions/ -name apcu.so)" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "apc.enable_cli=1" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY . /srv/

WORKDIR /srv
CMD ["bash", "boot.sh"]
```
---

# Dockerfile

```dockerfile
*FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install \
        mcrypt \
        bcmath \
        mbstring \
        zip \
        opcache \
        pdo pdo_pgsql

RUN yes | pecl install apcu xdebug-beta \
        && echo "extension=$(find /usr/local/lib/php/extensions/ -name apcu.so)" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "apc.enable_cli=1" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY . /srv/

WORKDIR /srv
CMD ["bash", "boot.sh"]
```
---

# Dockerfile

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

*RUN docker-php-ext-install \
*       mcrypt \
*       bcmath \
*       mbstring \
*       zip \
*       opcache \
*       pdo pdo_pgsql

RUN yes | pecl install apcu xdebug-beta \
        && echo "extension=$(find /usr/local/lib/php/extensions/ -name apcu.so)" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "apc.enable_cli=1" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY . /srv/

WORKDIR /srv
CMD ["bash", "boot.sh"]
```
---

# Dockerfile

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install \
        mcrypt \
        bcmath \
        mbstring \
        zip \
        opcache \
        pdo pdo_pgsql

RUN yes | pecl install apcu xdebug-beta \
        && echo "extension=$(find /usr/local/lib/php/extensions/ -name apcu.so)" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "apc.enable_cli=1" > /usr/local/etc/php/conf.d/apcu.ini \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY . /srv/

*WORKDIR /srv
*CMD ["bash", "boot.sh"]
```

---

# Docker Build

```bash

```

---

# Dockviz

```
├─sha256:b5c41 Virtual Size: 495.8 MB Tags: php:7.0-fpm
│ ├─sha256:a921a Virtual Size: 495.8 MB
│ │ └─sha256:8ed59 Virtual Size: 495.8 MB Tags: hotswap_php:latest
│ └─sha256:13276 Virtual Size: 541.8 MB
│   ├─sha256:734c2 Virtual Size: 544.2 MB
│   │ ├─sha256:21df5 Virtual Size: 592.9 MB Tags: localhost:5000/myproj/php:latest
│   │ └─sha256:505d6 Virtual Size: 592.9 MB Tags: my_proj_php:latest
│   └─sha256:2bc23 Virtual Size: 544.2 MB
│     ├─sha256:78ca0 Virtual Size: 588.5 MB Tags: nda_php:latest
│     ├─sha256:4821c Virtual Size: 593.6 MB Tags: todoapp_php:latest
│     └─sha256:d4079 Virtual Size: 593.6 MB Tags: devops_php:latest
```

---

# Start Container?

```bash
docker run
```

---

# Start Container

```bash
#!/usr/bin/env bash

# Disable xdebug in production environment
xdebug_config=/usr/local/etc/php/conf.d/xdebug.ini
if [ -f $xdebug_config ] && [ "$SYMFONY_ENV" == "prod" ]
    then
        rm $xdebug_config
fi

# Wait for postgres to start
echo -n "waiting for TCP connection to database:..."
while ! nc -z -w 1 database 5432 2>/dev/null
do
  echo -n "."
  sleep 1
done

# Prepare application
app/console cache:clear
php-fpm
```

---
# Start Container

```bash
#!/usr/bin/env bash

# Disable xdebug in production environment
xdebug_config=/usr/local/etc/php/conf.d/xdebug.ini
if [ -f $xdebug_config ] && [ "$SYMFONY_ENV" == "prod" ]
    then
        rm $xdebug_config
fi

# Wait for postgres to start
*echo -n "waiting for TCP connection to database:..."
*while ! nc -z -w 1 database 5432 2>/dev/null
*do
* echo -n "."
* sleep 1
*done

# Prepare application
app/console cache:clear
php-fpm
```

---
# Start Container

```bash
#!/usr/bin/env bash

# Disable xdebug in production environment
*xdebug_config=/usr/local/etc/php/conf.d/xdebug.ini
*if [ -f $xdebug_config ] && [ "$SYMFONY_ENV" == "prod" ]
*   then
*       rm $xdebug_config
*fi

# Wait for postgres to start
echo -n "waiting for TCP connection to database:..."
while ! nc -z -w 1 database 5432 2>/dev/null
do
  echo -n "."
  sleep 1
done

# Prepare application
*app/console cache:clear
*php-fpm
```

---

# Docker Compose

```yaml
# docker-compose.yml
version: "2"

services:
    php:
        build: '.'
        depends_on:
            - database
        env_file: .env
        volumes:
            - '.:/srv'

    database:
        image: postgres:9.4
        env_file: .env
        volumes:
            - dbdata:/var/lib/postgresql

volumes:
    dbdata:
        driver: local
```

---

# Split services configuration

```yaml
# docker-compose.test.yml
version: "2"

services:
    php:
        tty: true
        environment:
            SYMFONY_ENV: test

    database:
        volumes: []

    maildev:
        image: djfarrelly/maildev:0.12.1
```

---

### Multiple Docker Compose files

```terminal
docker-compose  -f 'docker-compose.yml' \
                -f 'docker-compose.test.yml' up -d
```


---

# Multiple Docker Compose files

```yaml
# result
version: "2"

services:
    php:
        build: '.'
        depends_on:
         - database
        env_file: .env
        volumes:
         - '.:/srv'
        tty: true
        environment:
            SYMFONY_ENV: test

    database:
        image: postgres:9.4
        env_file: .env

    maildev:
        image: djfarrelly/maildev:0.12.1
```
