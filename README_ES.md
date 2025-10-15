# 🧩 Proyecto Backend Full Stack – Django + FastAPI + MariaDB

**Autor:** Julio Ramenzoni ([@arbaruk](https://github.com/arbaruk))  
**Correo:** arbaruk@gmail.com  
**Repositorio:** [https://github.com/arbaruk/backend](https://github.com/arbaruk/backend)

---

## 📘 Descripción General

Este proyecto constituye una **plataforma backend unificada** que integra dos frameworks modernos:

- **Django** (para el sitio web principal y panel de administración).
- **FastAPI** (para la API REST asíncrona de alto rendimiento).
- **MariaDB 11.4** (como base de datos SQL robusta y open source).

El entorno está completamente **contenedorizado con Docker** y **automatizado con Makefiles**, preparado tanto para entornos de desarrollo como para despliegues de producción.

---

## 🚀 Objetivo del Proyecto

- Proveer una **arquitectura de backend moderna y segura** que pueda escalar fácilmente.
- Servir de base para proyectos **educativos, comerciales o institucionales**.  
- Facilitar la enseñanza de **DevOps, Python backend y CI/CD** mediante herramientas reales.
- Integrar prácticas de **seguridad, pruebas y tipado estático**.

---

## 🧰 Tecnologías Integradas

| Componente | Versión / Descripción |
|-------------|------------------------|
| **Python** | 3.12 |
| **Django** | 5.2.7 |
| **FastAPI** | 0.115+ |
| **MariaDB** | 11.4 |
| **Docker / Compose** | Docker Engine 26+ / Compose v2 |
| **Ruff / Mypy / Bandit / Pip-audit** | Análisis de calidad, tipos y seguridad |
| **pytest** | Testing unificado |
| **Makefile / PowerShell / Bash** | Scripts de automatización multiplataforma |
| **Traefik / Nginx** | Configuración lista para proxy inverso en producción |

---

## 🧪 Estructura de Directorios

```
backend/
├── apps/
│   ├── api/              # FastAPI app principal
│   │   └── app/main.py
│   └── web/              # Django app
│       ├── manage.py
│       └── project/
│           ├── settings.py
│           ├── urls.py
│           └── health.py
├── infra/
│   ├── nginx/            # Configuraciones de proxy Nginx
│   └── traefik/          # Configuración de Traefik (para producción)
├── scripts/
│   └── wait-for-db.sh    # Script de verificación de base de datos
├── dev/
│   └── docker-compose.yml
├── prod/
│   └── docker-compose.yml
├── Makefile              # Tareas automáticas
├── requirements.txt
├── Dockerfile
└── README.md
```

---

## 🧩 Comandos Clave

### 💻 Desarrollo (PowerShell o Linux/WSL)
```bash
# Construir y levantar todos los contenedores
docker compose up -d --build

# Verificar estado
docker compose ps

# Ejecutar tests
make test

# Análisis de seguridad
make audit

# Aplicar migraciones Django
docker compose exec web python /app/manage.py migrate

# Crear superusuario Django
docker compose exec web python /app/manage.py createsuperuser
```

---

## ☁️ Producción

```bash
# Construcción optimizada (multi-stage)
docker compose -f prod/docker-compose.yml up -d --build

# Logs
docker compose -f prod/docker-compose.yml logs -f

# Reiniciar servicios
docker compose -f prod/docker-compose.yml restart
```

---

## 🔁 Migración a un nuevo servidor

1. Instalar Docker + Compose.  
2. Clonar el repositorio:
   ```bash
   git clone https://github.com/arbaruk/backend.git && cd backend
   ```
3. Configurar variables `.env` y permisos:  
   ```bash
   cp .env.example .env
   chmod +x scripts/wait-for-db.sh
   ```
4. Levantar con Docker Compose según el entorno (`dev` o `prod`).

---

## 🧱 Diagrama de Arquitectura

```
                   ┌───────────────────────────────┐
                   │        Cliente / Browser      │
                   └──────────────┬────────────────┘
                                  │
                     Reverse Proxy (Traefik / Nginx)
                                  │
               ┌───────────────┬───────────────┐
               │                               │
         Django Web (8000)              FastAPI API (8001)
               │                               │
               └──────────────┬────────────────┘
                              │
                        MariaDB Database (3306)
```

---

## 🎓 Utilidad Comercial y Académica

### 💼 Comercial
- Prototipado rápido de servicios backend empresariales.  
- Base escalable para marketplaces, CRM, ERP o intranets.  
- Integración inmediata con panel de administración Django.

### 🎓 Académica
- Laboratorio completo para cursos de **Desarrollo Web Backend**, **DevOps**, **Ingeniería de Software**, **Ciberseguridad Aplicada** o **Cloud Computing**.  
- Muestra práctica de **CI/CD**, **contenedorización**, **testing automatizado** y **seguridad de dependencias**.

---

## 🧑‍💻 Autor
**Julio Ramenzoni**  
Email: [arbaruk@gmail.com](mailto:arbaruk@gmail.com)  
GitHub: [@arbaruk](https://github.com/arbaruk)

