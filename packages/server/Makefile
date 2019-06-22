build:
	docker build -f docker/httpd/Dockerfile -t server_http:latest .
	docker build -f docker/php/Dockerfile  --build-arg xdebug_on=false --build-arg xdebug_profile_on=on --build-arg production=true -t server_php:latest .

clean:
	docker-compose -f docker-compose.dev.yml down
run:
	docker-compose -f docker-compose.dev.yml up

import:
	mysql -h 127.0.0.1 -u root -p <~/Downloads/sql-dumps_serlo-2019-05-13.sql

