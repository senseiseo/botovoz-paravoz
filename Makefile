WEB_SERVICE=word-bot
WEB_CONTAINER=$(WEB_SERVICE)

DOCKER_WORKDIR=/app

DOCKER_ENV_PRODUCTION=eval `docker-machine env $(DOCKER_MACHINE_PRODUCTION)`
DOCKER_ENV_TEST=eval `docker-machine env $(DOCKER_MACHINE_TEST)`

DOCKER_COMPOSE_CMD=docker-compose
DOCKER_COMPOSE_CMD_PRODUCTION=$(DOCKER_ENV_PRODUCTION) && $(DOCKER_COMPOSE_CMD) -f docker-compose.yml -f docker-compose.production.yml --project-name=WEB_SERVICE
DOCKER_COMPOSE_CMD_TEST=$(DOCKER_ENV_TEST) && $(DOCKER_COMPOSE_CMD) -f docker-compose.yml -f docker-compose.test.yml --project-name=WEB_SERVICE

start.bot:
	bundle exec ruby lib/main.rb

start.bot.test:
	RACK_ENV=development bundle exec ruby lib/main.rb

run.bot.bash:
	docker exec -it $(WEB_CONTAINER) /bin/sh

logs.bot:
	docker logs --since 2m -f $(WEB_CONTAINER)

clear.docker:
	docker image prune -af && docker system prune -af
