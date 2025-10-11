# Makefile
# ---------------------------------------------------------
# Atajos para levantar el stack, entrar en contenedores,
# linting, tests y mantener actualizado pre-commit.
#
# Comentarios en lenguaje simple para recordar qué hace cada cosa.
# ---------------------------------------------------------

compose = docker compose

# Levantar en modo dev (usa perfiles dev por defecto)
up:
	$(compose) --env-file .env --profile dev up -d --build

# Levantar producción (local)
up-prod:
	$(compose) --env-file .env --profile prod up -d --build

# Bajar todo
down:
	$(compose) down

# Ver logs (útil para debug rápido)
logs:
	$(compose) logs -f --tail=200 web api db

# Abrir shell dentro del servicio web (Django)
shell-web:
	$(compose) exec web bash

# Abrir shell dentro del servicio api (FastAPI)
shell-api:
	$(compose) exec api bash

# Lint con Ruff (corre dentro del contenedor 'api' usando uv)
lint:
	$(compose) exec api uv run ruff check .

# Type checking con mypy
type:
	$(compose) exec api uv run mypy .

# Análisis SAST ligero con Bandit
sast:
	$(compose) exec api uv run bandit -r .

# Auditoría de dependencias (pip-audit)
audit:
	$(compose) exec api sh -lc "uv export -o /tmp/req.txt && pip-audit -r /tmp/req.txt || true"

# Ejecutar pytest dentro del contenedor api
pytest:
	$(compose) exec api uv run pytest -q

# ---------------------------------------------------------
# Actualizar hooks de pre-commit y commitear el cambio
# ---------------------------------------------------------
# Uso: make precommit-update
#
# Qué hace:
# 1) Ejecuta `pre-commit autoupdate` para actualizar las revisiones de los hooks.
# 2) Si `.pre-commit-config.yaml` cambió, añade y commitea ese archivo
#    con el mensaje "chore(pre-commit): update hooks".
# 3) Si no hay cambios, informa y no hace commit.
#
# Nota práctica:
# - Este target asume que estás en un repo git limpio o con cambios manejables.
# - Si prefieres revisar antes de commitear, ejecuta:
#     pre-commit autoupdate && git --no-pager diff .pre-commit-config.yaml
# ---------------------------------------------------------
precommit-update:
	@echo "Actualizando hooks de pre-commit..."
	@pre-commit autoupdate
	@# Si el archivo .pre-commit-config.yaml cambió en working tree, lo commiteo
	@# git diff --quiet devuelve 0 si NO hay diferencias, y 1 si hay diferencias
	@{ \
	  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
	    if git diff --quiet -- .pre-commit-config.yaml; then \
	      echo "No hay cambios en .pre-commit-config.yaml"; \
	    else \
	      git add .pre-commit-config.yaml; \
	      git commit -m "chore(pre-commit): update hooks"; \
	      echo "Se detectaron cambios y se commiteó .pre-commit-config.yaml"; \
	    fi; \
	  else \
	    echo "No estoy en un repo git. Ejecuta esto dentro de tu repositorio."; \
	    exit 1; \
	  fi \
	}

# ---------------------------------------------------------
# Helpers opcionales que puedes usar manualmente:
# ---------------------------------------------------------
precommit-run-all:
	@pre-commit run --all-files

precommit-install:
	@pre-commit install



# ---------------------------------------------------------
# USO
# ---------------------------------------------------------
#Para actualizar los hooks y que se cree el commit automático si hace falta:
#make precommit-update
#
#Si prefieres ver los cambios antes de commitear:
#pre-commit autoupdate
#git --no-pager diff .pre-commit-config.yaml
#
#y luego, si te gustan los cambios:
#git add .pre-commit-config.yaml
#git commit -m "chore(pre-commit): update hooks"
# ---------------------------------------------------------
