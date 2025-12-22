param(
    [string]$command = "up",
    [string]$env = "dev",
    [string]$compose_file = "docker-compose.dev.yml"
)

switch ($command.ToLower()) {
    "up" {
        docker compose -f $compose_file pull
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
    "help" {
        Write-Host "Available commands:" -ForegroundColor Green
        Write-Host "  up            - Pull images and start containers" -ForegroundColor White
        Write-Host "  down          - Stop and remove containers" -ForegroundColor White
        Write-Host "  logs          - Follow container logs" -ForegroundColor White
        Write-Host "  restart       - Stop and start containers" -ForegroundColor White
        Write-Host "  clean-volumes - Stop containers and remove volumes" -ForegroundColor White
        Write-Host "  help          - Show this help message" -ForegroundColor White
        Write-Host ""
        Write-Host "Parameters:" -ForegroundColor Green
        Write-Host "  -command      - Command to execute (default: up)" -ForegroundColor White
        Write-Host "  -env          - Environment for Infisical (default: dev)" -ForegroundColor White
        Write-Host "  -compose_file - Docker Compose file (default: docker-compose.dev.yml)" -ForegroundColor White
        Write-Host ""
        Write-Host "Examples:" -ForegroundColor Green
        Write-Host "  .\docker-compose.ps1 up" -ForegroundColor Yellow
        Write-Host "  .\docker-compose.ps1 -command logs" -ForegroundColor Yellow
        Write-Host "  .\docker-compose.ps1 -command up -env prod -compose_file docker-compose.prod.yml" -ForegroundColor Yellow
    }
    default {
        Write-Host "Unknown command: $command" -ForegroundColor Red
        Write-Host "Available commands: up, down, logs, restart, clean-volumes, help" -ForegroundColor White
        Write-Host "Use 'help' command for more information." -ForegroundColor White
    }
}