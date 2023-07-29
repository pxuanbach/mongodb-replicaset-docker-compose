createnet:
	docker network create mongors-network

up:
	docker compose up -d

down:
	docker compose down

downv:
	docker compose down -v

dbshell:
	docker compose exec mongo2 mongo

bash:
	docker compose exec mongo1 bash

initrs:
	docker compose exec mongo3 ./docker-entrypoint-initdb.d/rs-init.sh