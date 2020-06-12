#!/usr/bin/env bash

set -e

PGB_CONFIG="/etc/pgbouncer"

if [ ! -f "$PGB_CONFIG/pgbouncer.ini" ]; then 
  cp /usr/local/share/doc/pgbouncer/pgbouncer.ini $PGB_CONFIG/pgbouncer.ini
fi

if [ ! -f "$PGB_CONFIG/userlist.txt" ]; then 
  cp /usr/local/share/doc/pgbouncer/userlist.txt $PGB_CONFIG/userlist.txt
fi

rm -rf /var/run/pgbouncer/pgbouncer.pid

/usr/local/bin/pgbouncer /etc/pgbouncer/pgbouncer.ini