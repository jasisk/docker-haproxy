#!/bin/ash
set -e

if [ "$1" = 'haproxy' ]; then
    chown -R haproxy:haproxy .
    exec gosu haproxy "$@"
fi

exec "$@"
