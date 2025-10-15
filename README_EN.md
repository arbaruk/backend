# 🧩 Full Stack Backend Project – Django + FastAPI + MariaDB

**Author:** Julio Ramenzoni ([@arbaruk](https://github.com/arbaruk))  
**Email:** arbaruk@gmail.com  
**Repository:** [https://github.com/arbaruk/backend](https://github.com/arbaruk/backend)

---

## 📘 Overview

This project provides a **unified backend platform** integrating two modern Python frameworks:

- **Django** for the main website and administration panel.  
- **FastAPI** for the high-performance asynchronous REST API.  
- **MariaDB 11.4** as the open-source SQL database.

Everything runs in **Docker containers** with **Makefile automation**, supporting both development and production environments.

---

## 🎯 Purpose

- Deliver a **modern and secure backend architecture** ready for scaling.  
- Serve as a base for **educational, commercial, or institutional** use.  
- Teach students and professionals real-world **DevOps and backend practices**.  
- Integrate **security, typing, and testing best practices**.

---

## 🧰 Tech Stack

| Component | Version / Description |
|------------|----------------------|
| **Python** | 3.12 |
| **Django** | 5.2.7 |
| **FastAPI** | 0.115+ |
| **MariaDB** | 11.4 |
| **Docker / Compose** | Engine 26+ / Compose v2 |
| **Ruff / Mypy / Bandit / Pip-audit** | Code quality, typing, and security tools |
| **pytest** | Unified testing framework |
| **Makefile / PowerShell / Bash** | Cross-platform automation scripts |
| **Traefik / Nginx** | Ready for reverse-proxy in production |

---

## 🧪 Directory Structure

```
backend/
├── apps/
│   ├── api/              # FastAPI main app
│   │   └── app/main.py
│   └── web/              # Django web app
│       ├── manage.py
│       └── project/
│           ├── settings.py
│           ├── urls.py
│           └── health.py
├── infra/
│   ├── nginx/
│   └── traefik/
├── scripts/
│   └── wait-for-db.sh
├── dev/
│   └── docker-compose.yml
├── prod/
│   └── docker-compose.yml
├── Makefile
├── requirements.txt
├── Dockerfile
└── README.md
```

---

## 💻 Development Commands

```bash
docker compose up -d --build
docker compose ps
make test
make audit
docker compose exec web python /app/manage.py migrate
docker compose exec web python /app/manage.py createsuperuser
```

---

## ☁️ Production

```bash
docker compose -f prod/docker-compose.yml up -d --build
docker compose -f prod/docker-compose.yml logs -f
docker compose -f prod/docker-compose.yml restart
```

---

## 🔁 Migration Guide

1. Install Docker + Compose.  
2. Clone:
   ```bash
   git clone https://github.com/arbaruk/backend.git && cd backend
   ```
3. Configure environment variables:
   ```bash
   cp .env.example .env
   chmod +x scripts/wait-for-db.sh
   ```
4. Deploy using Docker Compose.

---

## 🧱 Architecture Diagram

```
                   ┌───────────────────────────────┐
                   │       Client / Browser        │
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

## 🧩 Commercial & Educational Applications

### 💼 Commercial Use
- Rapid prototyping for enterprise-grade backend services.  
- Scalable foundation for marketplaces, CRMs, or internal systems.  
- Integrated Django admin for immediate management.

### 🎓 Academic Use
- Perfect for **university courses** in Backend Development, DevOps, Cybersecurity, or Cloud.  
- Demonstrates **CI/CD, container orchestration, automated testing, and secure deployment**.

---

## 🧑‍💻 Author
**Julio Ramenzoni**  
Email: [arbaruk@gmail.com](mailto:arbaruk@gmail.com)  
GitHub: [@arbaruk](https://github.com/arbaruk)
