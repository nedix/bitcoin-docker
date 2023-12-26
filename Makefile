DOCKER_COMPOSE_CMD := docker compose

up:
	@$(DOCKER_COMPOSE_CMD) up -d bitcoin-full bitcoin-light

down:
	@$(DOCKER_COMPOSE_CMD) down --remove-orphans

setup:
	@test -e .env || cp .env.example .env
	@$(DOCKER_COMPOSE_CMD) pull --ignore-buildable
	@$(DOCKER_COMPOSE_CMD) build
	@make s3-fresh
	@make up

destroy:
	@$(DOCKER_COMPOSE_CMD) down --remove-orphans --volumes

fresh:
	@make destroy
	@make setup

s3-fresh:
	@$(DOCKER_COMPOSE_CMD) up -d --wait minio
	@$(DOCKER_COMPOSE_CMD) exec minio sh -c ' \
		mc mb "data/minio/$${MINIO_BUCKET}" \
		&& mc anonymous set none "data/minio/$${MINIO_BUCKET}" \
	'
