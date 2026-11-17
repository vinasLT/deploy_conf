param(
    [string]$command = "up",
    [string]$env = "dev",
    [string]$compose_file = ""
)

# env: dev | demo | prod  (demo uses the Infisical "prod" environment)
$infisical_env = $env
switch ($env.ToLower()) {
    "prod" { if (-not $compose_file) { $compose_file = "prod/docker-compose.yml" } }
    "demo" { if (-not $compose_file) { $compose_file = "demo/docker-compose.demo.yml" }; $infisical_env = "prod" }
    default { if (-not $compose_file) { $compose_file = "dev/docker-compose.dev.yml" } }
}

switch ($command.ToLower()) {
    { $_ -in "up", "deploy" } {
        # pull runs under Infisical too: image tags come from CONTAINER_TAG
        infisical run --env=$infisical_env -- docker compose -f $compose_file pull
        infisical run --env=$infisical_env -- docker compose -f $compose_file up -d --remove-orphans
    }
    "down" {
        docker compose -f $compose_file down --remove-orphans
    }
    "logs" {
        docker compose -f $compose_file logs -f
    }
    "restart" {
        docker compose -f $compose_file down --remove-orphans
        infisical run --env=$infisical_env -- docker compose -f $compose_file up -d --remove-orphans
    }
    "clean-volumes" {
        docker compose -f $compose_file down -v
    }
    "help" {
        Write-Host "Available commands:" -ForegroundColor Green
        Write-Host "  up / deploy   - Pull images and start/update containers" -ForegroundColor White
        Write-Host "  down          - Stop and remove containers" -ForegroundColor White
        Write-Host "  logs          - Follow container logs" -ForegroundColor White
        Write-Host "  restart       - Stop and start containers" -ForegroundColor White
        Write-Host "  clean-volumes - Stop containers and remove volumes" -ForegroundColor White
        Write-Host "  help          - Show this help message" -ForegroundColor White
        Write-Host ""
        Write-Host "Parameters:" -ForegroundColor Green
        Write-Host "  -command      - Command to execute (default: up)" -ForegroundColor White
        Write-Host "  -env          - dev (default), demo or prod" -ForegroundColor White
        Write-Host "  -compose_file - Override the Docker Compose file (default depends on -env)" -ForegroundColor White
        Write-Host ""
        Write-Host "Examples:" -ForegroundColor Green
        Write-Host "  .\run.ps1 up" -ForegroundColor Yellow
        Write-Host "  .\run.ps1 -command logs" -ForegroundColor Yellow
        Write-Host "  .\run.ps1 -command up -env prod" -ForegroundColor Yellow
    }
    default {
        Write-Host "Unknown command: $command" -ForegroundColor Red
        Write-Host "Available commands: up, deploy, down, logs, restart, clean-volumes, help" -ForegroundColor White
        Write-Host "Use 'help' command for more information." -ForegroundColor White
    }
}
