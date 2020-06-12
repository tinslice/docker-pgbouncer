#!make

include .env

build:
	docker build --pull \
		--build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg PG_BOUNCER_VERSION=${PG_BOUNCER_VERSION} \
		-f Dockerfile -t tinslice/pgbouncer .

push:
	docker push tinslice/pgbouncer

clean:
	docker rmi tinslice/pgbouncer