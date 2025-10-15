Pasos rápidos (desarrollo):

1) Copia 'requirements-dev.txt' a la raíz de D:\docker\backend
2) Copia/merge el 'Makefile' con el de tu proyecto (o reemplázalo si prefieres estos targets)
3) Levanta dev:
   docker compose -f dev\docker-compose.yml --env-file .env up -d --build

4) Instala dev-deps dentro del contenedor web:
   make install-dev-deps
   # o:
   docker compose -f dev\docker-compose.yml --env-file .env exec -T web /workspace/.venv/bin/pip install -r /app/../requirements-dev.txt

5) Corre:
   make lint
   make typecheck
   make test
