# ---------- Etapa base ----------
FROM python:3.12-slim AS base

# Variables de entorno globales
ENV TZ=America/Santiago \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_NO_CACHE_DIR=1 \
    UV_SYSTEM_PYTHON=1

# -- Instalo dependencias del sistema necesarias para compilar paquetes nativos --
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    curl \
    git \
    ca-certificates \
    tzdata \
    default-libmysqlclient-dev \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar uv
# Nota: el installer de uv deja binarios en ~/.local/bin; se añaden al PATH
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    ln -s /root/.local/bin/uv /usr/local/bin/uv

# Crear usuario no-root (UID 1000 para coincidir con host típico)
RUN useradd -m -u 1000 -s /bin/bash appuser || true
WORKDIR /workspace
RUN chown -R appuser:appuser /workspace
USER appuser

# ---------- Etapa deps: instalar dependencias en .venv ----------
FROM base AS deps
WORKDIR /workspace
COPY --chown=appuser:appuser pyproject.toml pyproject.toml
COPY --chown=appuser:appuser pyproject.lock pyproject.lock 2>/dev/null || true
# Crear virtualenv y sincronizar
RUN uv sync --no-install-project || true
# Nota: en caso de tener lockfile usar `uv sync --frozen`

# ---------- Etapa de desarrollo ----------
FROM base AS dev
WORKDIR /app
ENV PATH="/workspace/.venv/bin:${PATH}" \
    WATCHFILES_FORCE_POLLING=true
# Copiar venv desde deps si existe
COPY --from=deps /workspace/.venv /workspace/.venv
# No copiar código; en dev se monta el volumen
EXPOSE 8000 8001
CMD ["bash"]

# ---------- Etapa de producción (más light) ----------
FROM python:3.12-slim AS prod
ENV TZ=America/Santiago \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Copiar solo lo necesario desde deps (.venv)
COPY --from=deps /workspace/.venv /workspace/.venv
ENV PATH="/workspace/.venv/bin:${PATH}"
# Copiar la app
COPY --chown=appuser:appuser . /app
USER appuser
EXPOSE 8000 8001
CMD ["bash"]
