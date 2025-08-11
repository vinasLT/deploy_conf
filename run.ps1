param(
    [string]$command = "up",
    [string]$env = "dev",
    [string]$compose_file = "docker-compose.dev.yml"
)

switch ($command.ToLower()) {
    "up" {
        infisical run --env=$env -- docker compose -f $compose_file up -d
    }
    "down" {
        docker compose -f $compose_file down
    }
    "logs" {
        docker compose -f $compose_file logs -f
    }
    "restart" {
        docker compose -f $compose_file down
        infisical run --env=$env -- docker compose -f $compose_file up -d
    }
    "clean-volumes" {
        docker compose -f $compose_file down -v
    }
    default {
        Write-Host "Unknown command: $command"
        Write-Host "Available commands: up, down, logs, restart, clean-volumes"
    }
}