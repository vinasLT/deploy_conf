INFISICAL_ENV ?= dev
COMPOSE_FILE ?= docker-compose.dev.yml

up:
	infisical run --env=$(INFISICAL_ENV) -- docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

restart: down up
