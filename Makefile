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
	@$(DOCKER_COMPOSE_CMD) down --remove-orphans --volumes

fresh:
	@make destroy
	@make setup

test: DOCKER_COMPOSE_CMD := docker compose -f docker-compose.test.yml --env-file .env.test
test:
	@./tests/integration/it_should_pass_all_integration_tests.sh
