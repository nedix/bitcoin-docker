DOCKER_COMPOSE_CMD := docker compose

up:
	@$(DOCKER_COMPOSE_CMD) up -d bitcoin-external bitcoin-internal

down:
	@$(DOCKER_COMPOSE_CMD) down --remove-orphans

setup:
	@test -e .env || cp .env.example .env
	@$(DOCKER_COMPOSE_CMD) pull --ignore-buildable
	@$(DOCKER_COMPOSE_CMD) build
	@make up

destroy:
	@$(DOCKER_COMPOSE_CMD) kill --remove-orphans
	@$(DOCKER_COMPOSE_CMD) rm --volumes --force

fresh:
	@make destroy
	@make setup

test: DOCKER_COMPOSE_CMD := docker compose -f docker-compose.test.yml --env-file .env.test
test:
	@tests/e2e/index.sh
