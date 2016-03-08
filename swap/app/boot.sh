#!/usr/bin/env bash

set -e

# Wait for container dependencies to be healthy enough
./boot_healthcheck

# Simulate long starting container
# Migration scripts, cache warmup and so on
sleep 10

# Tell to health checker script that we are done
touch .healthy

# Now handle connections
php-fpm