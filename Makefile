INFISICAL_ENV ?= dev
COMPOSE_FILE ?= docker-compose.dev.yml

.PHONY: up down logs restart clean-volumes pull help

up: pull
	infisical run --env=$(INFISICAL_ENV) -- docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

restart: down up

clean-volumes:
	docker compose -f $(COMPOSE_FILE) down -v

pull:
	docker compose -f $(COMPOSE_FILE) pull

help:
	@echo "Available commands:"
	@echo "  up            - Pull images and start containers"
	@echo "  down          - Stop and remove containers"
	@echo "  logs          - Follow container logs"
	@echo "  restart       - Stop and start containers"
	@echo "  clean-volumes - Stop containers and remove volumes"
	@echo "  pull          - Pull latest images"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  INFISICAL_ENV - Environment for Infisical (default: dev)"
	@echo "  COMPOSE_FILE  - Docker Compose file (default: docker-compose.dev.yml)"