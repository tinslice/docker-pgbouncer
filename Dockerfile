ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION}

ARG PG_BOUNCER_VERSION=1.13.0
ADD http://www.pgbouncer.org/downloads/files/${PG_BOUNCER_VERSION}/pgbouncer-${PG_BOUNCER_VERSION}.tar.gz ./tmp/pgbouncer.tar.gz

RUN apk add --update --no-cache \
    udns postgresql-client libevent libtool \
    autoconf make autoconf-doc automake udns-dev gcc openssl-dev pkgconfig libc-dev libevent-dev openssl-dev

RUN cd /tmp && tar xvfz pgbouncer.tar.gz && cd pgbouncer-${PG_BOUNCER_VERSION} && \
    ./configure --prefix=/usr/local --with-udns && \
    make && make install && \
    addgroup -g 70 -S postgres 2>/dev/null && \
    adduser -u 70 -S -D -H -h /var/lib/postgresql -g "Postgres user" -s /bin/sh -G postgres postgres 2>/dev/null && \
    mkdir -p /var/run/pgbouncer /etc/pgbouncer /var/log/pgbouncer && \
    chown -R postgres:postgres /var/run/pgbouncer /etc/pgbouncer /var/log/pgbouncer && \
    cp /usr/local/share/doc/pgbouncer/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini && \
    cp /usr/local/share/doc/pgbouncer/userlist.txt /etc/pgbouncer/userlist.txt && \
    rm -rf /tmp/pgbouncer* && \
    apk del --purge autoconf make autoconf-doc automake udns-dev gcc openssl-dev pkgconfig libc-dev libevent-dev openssl-dev

COPY fs/ /

USER postgres
EXPOSE 5432

VOLUME [ "/etc/pgbouncer", "/var/log/pgbouncer"]

ENTRYPOINT [ "/prepare-env-and-run.sh" ]