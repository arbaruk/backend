param([Parameter(Position=0)][ValidateSet('test','lint','typecheck','up-dev','down-dev','logs-dev')][string]$Task)

$compose = 'dev\docker-compose.yml'
$envfile = '.env'

switch ($Task) {
  'test'      { docker compose -f $compose --env-file $envfile exec -T web /bin/sh -lc 'export DJANGO_SETTINGS_MODULE=project.settings; /workspace/.venv/bin/pytest -q; ec=$$?; if [ $$ec -eq 5 ]; then echo "pytest: no tests collected (OK)"; exit 0; else exit $$ec; fi' }
  'lint'      { docker compose -f $compose --env-file $envfile exec -T web /workspace/.venv/bin/ruff check /app }
  'typecheck' { docker compose -f $compose --env-file $envfile exec -T web /workspace/.venv/bin/mypy /app }
  'up-dev'    { docker compose -f $compose --env-file $envfile up -d --build }
  'down-dev'  { docker compose -f $compose --env-file $envfile down }
  'logs-dev'  { docker compose -f $compose --env-file $envfile logs -f --tail 200 }
  default     { Write-Host "Uso: .\tasks.ps1 [test|lint|typecheck|up-dev|down-dev|logs-dev]" }
}
