Container Swap example
=============================

This example illustrates how to swap containers for single docker-compose service. You could use it to minimize downtime from seconds (or minutes in case of complex bootstrap process) to milliseconds.

**Note**: This approach should not be considered as zero-downtime, since there is a very small time gap between old container stop and nginx reload. But you can modify nginx settings to retry failed requests and solve this issue on that level.

## How it works

Basically this example is relies on ability of `docker-compose` to scale number of containers per service. When you are deploying new image, you are running two versions of container at the same time.

When you are started new version of container, you should also run migration scripts, warmup caches and so on. So we should wait until it ready to handle requests. This means that our container should provide a way to check it health by runing some command inside container. Something like:

```bash
docker exec $newContainer bash c "./healthcheck"
```

The main thing is how docker resolves DNS for services. If you are running two containers for single service, it stel will route all traffic to old one. So we could wait for container to be healthy eniught and just stop old one and reload nginx.

To make it real zero-downtime, you could use the same script, but you should not rely on docker dns for host resolution. You could use confd to dynamicly update ngonx host config and use some key-value store (redis for example) to store address of host. It that case you could manually update host info before killing old container.

## Try out!

First of all, we should link first version of our application as source:

```
cp sources/v1.php app/app.php
```

Then start application:

```
docker-compose up -d
```

This command will build first version of our application image. In this example app will be started on port `8080`, you could check it in your browser.

Now, when everything works, let's update application and build new version of application image:

```
cp sources/v2.php app/app.php
docker-compose build app
```

And now, here comes the magic! Let's replace containers:

```
./scripts/swap app "./healthcheck"
```

This script will start new container for given service, will wait until it's ready to handle requests, and then just kills the old one! After that it will reload nginx configs to make sure that is uses new container.

Please see source of `scripts/swap` for details.

## Possible problems

This approach uses `scale` command, which may be removed in next releases of `docker-compose` [#2496](https://github.com/docker/compose/issues/2496). Currently this is the simplest way to make deployment without downtime of your application.

