class: center, middle

# Docker, what is all about

Intellectsoft LTD

---
class: center, middle
# Who I am

Full-stack developer at Intellectsoft LTD.

http://github.com/fesor

---
class: center, middle
# Why Docker?

---
class: center, bg-cover, bg-right
background-image: url(img/cool_guy.jpg)
# All cool guys use docker!

---
class: right, bottom, bg-cover, img-slide, dark
background-image: url(img/blog-banner-dr-evil.png)

# Right...

---
class: center, middle
# 90's

---
class: center, middle
# 1999

(Matrix, Phantom Menace, Futurama, Family Guy)

---
class: center, middle
### Adaptive Software Development

## Extreme Programming

# Agile

## Lean

---
class: center
# Iterative development

.img-60[![](img/agile.svg)]

---
class: center, middle, bg-cover, text-overlay
background-image: url(img/maxresdefault.jpg)
# Microservices!

---
class: center, middle

## BSD Jail

## Sun Solaris Container

## OpenVZ

---
class: center, middle

## LXC, cgroups, namespaces...

---
class: center, middle
# Puppet, Chief, Ansible

---
class: center, middle
.img-80[![](img/ops_problem_now.jpg)]

---
class: center, bottom, bg-cover, img-slide, large-headers, dark
background-image: url(img/devops.jpg)
# DevOps

---
class: center, middle
# Vagrant

---
class: center, middle
![](img/slowpoke.png)

---
class: center, middle

# Continuous Delivery

---
class: center, middle

# We need a ~~hero~~ new tool

---
class: center, middle
# Docker!

---
class: center
.docker-logo[![](img/docker_logo.png)]

![](img/docker_engine.svg)

---
class: center, middle
# Unix: everything is a file

---
class: center, middle
# UnionFS

### BtrFS, AuFS, OverlayFS
---
class: larger-code
# Dockerfile

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install \
        mcrypt bcmath mbstring zip \
        opcache pdo pdo_pgsql

COPY . /srv/

WORKDIR /srv
CMD ["bash", "boot.sh"]
```

---
class: center, middle

# Dockerfile and Layers
.img-80[![](img/dockerfile_layers.svg)]


---

class: larger-code
# Dockerfile

```dockerfile
*FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install \
        mcrypt bcmath mbstring zip \
        opcache pdo pdo_pgsql

COPY . /srv/

WORKDIR /srv
CMD ["bash", "boot.sh"]
```
---
class: larger-code
# Dockerfile

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

*RUN docker-php-ext-install \
*       mcrypt bcmath mbstring zip \
*       opcache pdo pdo_pgsql

COPY . /srv/

WORKDIR /srv
CMD ["bash", "boot.sh"]

```
---
class: larger-code
# Dockerfile

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install \
        mcrypt bcmath mbstring zip \
        opcache pdo pdo_pgsql

COPY . /srv/

WORKDIR /srv
*CMD ["bash", "boot.sh"]
```

---
class: larger-code
# Docker Build

```bash
docker build -t myproject/php:latest .

```

---
class: larger-code
# Dockviz

```
├─sha256:b5c41: 495.8 MB Tags: php:7.0-fpm
│ ├─sha256:a921a: 495.8 MB
│ │ └─sha256:8ed59: 495.8 MB Tags: hotswap_php:latest
│ └─sha256:13276: 541.8 MB
│   ├─sha256:734c2: 544.2 MB
│   │ ├─sha256:21df5: 592.9 MB Tags: repo:5000/myproj/php:latest
│   │ └─sha256:505d6: 592.9 MB Tags: my_proj_php:latest
│   └─sha256:2bc23: 544.2 MB
│     ├─sha256:78ca0: 588.5 MB Tags: nda_php:latest
│     ├─sha256:4821c: 593.6 MB Tags: todoapp_php:latest
│     └─sha256:d4079: 593.6 MB Tags: devops_php:latest
```

---
class: middle, center
# Single Responsibility
---
class: command-example
# Start Container

```bash
docker run --name test -it myproject/php:latest
```

---

# Start Container...

```bash
#!/usr/bin/env bash

# Disable xdebug in production environment
xdebug_config=/usr/local/etc/php/conf.d/xdebug.ini
if [ -f $xdebug_config ] && [ "$SYMFONY_ENV" == "prod" ]
    then
        rm $xdebug_config
fi

*# Wait for postgres to start
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
class: middle larger-code
# Volumes

--

```
docker run -it  --rm                          \
*      -v '/var/lib/postgresql'               \
*      -v 'configs:/etc/postgresql/9.4/main/' \
       postgres:9.4
```

---
class: center, middle

# Named Volumes

### No more data-only container madness

---

class: center, middle, larger-code

# Named Volumes

```
docker volume create dbdata --driver local
```

---

class: center, middle, larger-code

# Named Volumes

```
docker run -it  -rm                    \
*      -v 'dbdata:/var/lib/postgresql' \
       postgres:9.4
```

---
class: center, middle
# Networking

---

# Networking: Bridge

---

# Networking: Host

---

# Networking: Container


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
class: larger-code
# Multiple Docker Compose files

```terminal
docker-compose  -f 'docker-compose.yml'          \
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

---

# So... How to share my project?
---

# Docker Hub

### Just like GitHub for infrastructure!

---

# Docker Distribution

### Just like GitLab for infrastructure!

---

# Deployment?

---

# Client-Server Architecture

---

# Docker machine

```
docker machine add                \
       --driver generic           \
       --generic-host 16.45.12.54 \
       --generic-ssh-user root    \
       my-remove-host

```
---

# Docker machine

```
docker machine add
*       --driver digitalocean

```
---

# Deployment!

```
eval "$(docker-machine env my-host)"

docker-compose -f docker-compose.prod.yml up
```

---

# How about multiple hosts?

TODO: scheme

---

# Links Multiple Hosts

TODO: scheme

---

# Networking: Overlay

---

# Let is Swarm

---

# Service Discovery

### Etcd, Consul, Zookeeper

---

# Zero Downtime Deployment!

--

## Docker-Compose wont help you...

---

# Zero Downtime Deployment!

## key-value store, confd

---

# Every tool have it's own problems

---

# Works hightly unstable on old kernels

---

## Remove stopped containers

```
docker rm $(docker ps -q -f status=exited)
```

## Remove untagged images

```
docker rmi $(docker images -q -f "dangling=true")

```

## Remove old volumes

```
docker volume rm $(docker volume ls -qf dangling=true)
```

---

# MacOS guys?

--

- docker-machine and virtualbox
- dinghy (adds NFS, dns server, http proxy...)

---

# Windows guys?

--

## Just use docker machine so far...

