# backend
# README — Entorno Docker (Django + FastAPI + MariaDB)

> Archivo explicativo en lenguaje simple: qué hace el Docker, estructura de archivos, para qué sirve cada archivo, cómo iniciarlo desde Docker Desktop o consola, extras útiles (VS Code), y cómo integrar todo con GitHub.  
> Guarda este archivo y revísalo antes de lanzar el `docker-compose`.

---

## 1) ¿Qué hace y para qué sirve este Docker?

Este proyecto crea un **entorno de desarrollo reproducible** usando Docker y Docker Compose para trabajar con:

- **Django** (sitio web) en desarrollo (puerto `8000`).
- **FastAPI** (API) en desarrollo (puerto `8001`).
- **MariaDB** como base de datos (servicio `db`).
- Herramientas de desarrollo: hot-reload, pytest, ruff, mypy.
- Herramientas de seguridad: bandit y pip-audit.
- Multi-stage `Dockerfile` para builds reproducibles y una imagen de producción más ligera.
- Configuraciones para trabajar cómodamente desde **VS Code** (devcontainer, tasks, debugging).

Objetivo: que cualquiera del equipo ejecute el mismo entorno con un solo comando y tenga las mismas dependencias y comportamientos.

---

## 2) Estructura de archivos (dónde van)

```
/ (raíz del repo)
├─ .env                   -> variables de entorno (NO commitear)
├─ .dockerignore
├─ .gitignore
├─ .pre-commit-config.yaml
├─ docker-compose.yml
├─ Dockerfile
├─ Makefile
├─ pyproject.toml
├─ .devcontainer/
│  └─ devcontainer.json
├─ .vscode/
│  ├─ settings.json
│  ├─ tasks.json
│  └─ launch.json
├─ apps/
│  ├─ api/
│  │  └─ app/
│  │     └─ main.py
│  └─ web/
│     ├─ manage.py
│     └─ project/
│        ├─ settings.py
│        ├─ urls.py
│        └─ health.py
└─ tests/
   ├─ api/
   │  └─ test_health.py
   └─ web/
      └─ test_health.py
```

> Nota: Si tu copia difiere (carpetas con comas, nombres duplicados, archivos en subcarpetas inesperadas), **sube el zip del directorio**. Yo lo reviso y te indico cambios concretos antes de levantar Docker.

---

## 3) ¿Para qué sirve cada archivo? (explicación simple)

- **`.env`**: contiene variables sensibles (DB credentials, SECRET_KEY). No subir a Git. Usa `.env.example` como plantilla.
- **`.dockerignore`**: evita que archivos grandes o secretos entren en la imagen Docker.
- **`.gitignore`**: evita subir archivos locales/comunes no deseados.
- **`.pre-commit-config.yaml`**: hooks que corren antes de cada commit (formato, lint, SAST).
- **`docker-compose.yml`**: orquesta servicios: db, web (dev/prod), api (dev/prod). Define redes y healthchecks.
- **`Dockerfile`**: multi-stage build. Etapas: `base` (toolchain), `deps` (venv), `dev` (entorno para desarrollo), `prod` (imagen final).
- **`Makefile`**: atajos (up, down, lint, pytest, precommit-update).
- **`pyproject.toml`**: dependencias del proyecto y extras dev (pytest, ruff, mypy, bandit, pip-audit).
- **`.devcontainer/devcontainer.json`**: configuración para abrir el proyecto dentro de un contenedor dev en VS Code.
- **`.vscode/settings.json`**: ajustes del editor para formateo, lint y pruebas.
- **`.vscode/tasks.json`**: tareas para levantar el stack y ejecutar comandos comunes desde VS Code.
- **`.vscode/launch.json`**: configuraciones para depuración de Django y FastAPI.
- **`apps/api/app/main.py`**: FastAPI app (endpoints `/`, `/healthz`, `/readyz`).
- **`apps/web/manage.py`**: script de Django para migraciones y runserver.
- **`apps/web/project/settings.py`**: configuración Django (DB, TZ, seguridad condicional por DEBUG).
- **`apps/web/project/urls.py`** y **`health.py`**: rutas mínimas y endpoint health.

---

## 4) Cómo iniciarlo desde consola (pasos seguros)

1. **Copia la plantilla `.env` y rellena los valores**
   ```bash
   cp .env.example .env
   # Edita .env y pon DB_NAME, DB_USER, DB_PASSWORD, DB_ROOT_PASSWORD, DJANGO_SECRET_KEY...
   ```

2. **Asegura que `.env` no está trackeado**
   ```bash
   git rm --cached .env || true
   echo ".env" >> .gitignore
   git add .gitignore
   git commit -m "chore: ignore .env" || true
   ```

3. **Instala pre-commit y ejecuta hooks una vez (recomendado)**
   ```bash
   pip install pre-commit
   pre-commit install
   pre-commit run --all-files
   ```

4. **Levantar en modo desarrollo**
   ```bash
   docker compose --env-file .env --profile dev up -d --build
   ```

5. **Ver logs (útil para debug)**
   ```bash
   docker compose logs -f --tail=200 web api db
   ```

6. **Bajar servicios**
   ```bash
   docker compose down
   ```

7. **Verificar endpoints**
   - Django: `http://localhost:8000/healthz`
   - FastAPI: `http://localhost:8001/healthz`

---

## 5) Cómo iniciarlo desde Docker Desktop (GUI)

1. Abrir **Docker Desktop**.
2. Ir a **Containers / Apps** o a **Compose** (según versión).
3. Añadir el `docker-compose.yml` del repo (o arrastrar la carpeta).
4. Start / Stop desde la UI; ver logs y healthchecks desde la vista de cada servicio.
5. Recomiendo usar la consola (CLI) para ver errores completos, pero la UI es útil si prefieres clicks.

---

## 6) Extras y cómo usarlos (por qué son útiles)

### Makefile
- Reduce comandos largos a `make up`, `make down`, `make lint`, `make pytest`.
- `make precommit-update` actualiza hooks y hace commit si cambiaron.

### pre-commit
- Ejecuta linters (ruff), formateadores (black), isort, mypy y bandit antes de cada commit.
- Evita subir código que rompa estilo o tenga errores obvios.
- Usar:
  ```bash
  pre-commit install
  pre-commit run --all-files
  ```

### VS Code devcontainer
- "Reopen in Container" abre el workspace dentro del contenedor; así usas exactamente el mismo entorno que Docker.
- Instala extensiones dentro del contenedor y el intérprete será `/workspace/.venv/bin/python`.

### Debugging en VS Code
- Para **Django**: usar `python -m debugpy --listen 0.0.0.0:5678 manage.py runserver 0.0.0.0:8000` dentro del contenedor `web`, luego Attach desde VS Code.
- Para **FastAPI**: se puede lanzar desde `launch.json` con `module: uvicorn` y poner breakpoints.

### Thunder Client / REST Client
- Guarda y reusa peticiones HTTP, útil para probar endpoints sin abrir navegador.

### SQLTools
- Conecta a MariaDB para hacer consultas rápidas (usa port-forward o expone temporalmente puerto local).

---

## 7) Complementos recomendados para VS Code — por qué y cómo se usan

Instala estas extensiones (línea `code --install-extension` incluida):

- `ms-python.python` (Pylance integrado): autocompletado, debugging, test explorer.
  ```bash
  code --install-extension ms-python.python
  code --install-extension ms-python.vscode-pylance
  ```
- `charliermarsh.ruff`: linter rápido, muy veloz en grandes bases de código.
  ```bash
  code --install-extension charliermarsh.ruff
  ```
- `esbenp.prettier-vscode`: formateo de JSON/TOML/otros.
- `ms-azuretools.vscode-docker`: gestionar contenedores desde VS Code.
- `ms-vscode-remote.remote-containers` / `ms-vscode-remote.remote-wsl`: abrir en contenedor o WSL.
- `humao.rest-client` o `rangav.vscode-thunder-client`: para probar APIs.
- `mtxr.sqltools` + driver MySQL: para consultar la DB desde VS Code.
- `eamodio.gitlens`: historial y control de git mejorado.

**Cómo usarlas**
- Reopen in Container → VS Code instalará las extensiones dentro del contenedor y la configuración `.vscode/settings.json` apuntará al intérprete correcto.
- Usa la paleta (`Ctrl+Shift+P`) → `Tasks: Run Task` → `Compose: Up (dev)` para levantar servicios desde VS Code.

---

## 8) Integración con GitHub (mantener el repo actualizado)

### Repositorio y push inicial
1. Crear repo en GitHub.
2. Añadir remote y hacer push:
   ```bash
   git remote add origin git@github.com:<usuario>/<repo>.git
   git push -u origin main
   ```

### CI recomendado (GitHub Actions)
- Crear `.github/workflows/ci.yml` para:
  - Ejecutar `pre-commit run --all-files`
  - Instalar dependencias y ejecutar `pytest`
  - Ejecutar `pip-audit` y `bandit`
- Ejemplo minimal (añadir en tu repo):
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      - name: Install tools
        run: |
          python -m pip install --upgrade pip
          pip install pre-commit pip-audit pytest
      - name: Run pre-commit
        run: pre-commit run --all-files
      - name: Run tests
        run: pytest -q
      - name: Pip audit
        run: pip-audit || true
```

### Branch protection y PRs
- Protege `main`: requerir PRs, revisión de al menos 1 revisor, checks de CI verdes antes de merge.

---

## 9) Checklist final (antes del primer `docker compose up`)

1. Mover/renombrar carpetas con nombres extraños (por ejemplo `.devcontainer`, `.dockerignore`) si existen con errores de nombre.
2. Asegurar `.pre-commit-config.yaml` en la raíz.
3. `manage.py` en `apps/web/manage.py`.
4. Renombrar etapa prod en Dockerfile si difiere (`prod`).
5. `.env` debe existir localmente y no estar en git.
6. Ejecutar `pre-commit run --all-files` y solucionar issues.
7. Luego:
   ```bash
   docker compose --env-file .env --profile dev up -d --build
   ```

---
