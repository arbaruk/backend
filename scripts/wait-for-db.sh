#!/usr/bin/env bash
set -euo pipefail

host="${1:-db}"
user="${2:-appuser}"
pass="${3:-apppass}"
port="${4:-3306}"
shift 4 || true

echo "Waiting for MariaDB at ${host}:${port} (user=${user})..."

while true; do
  /workspace/.venv/bin/python - <<'PY'
import os, sys
import pymysql

host = os.environ.get("DB_HOST", os.environ.get("host", "db"))
user = os.environ.get("DB_USER", os.environ.get("user", "appuser"))
password = os.environ.get("DB_PASSWORD", os.environ.get("pass", "apppass"))
try:
    port = int(os.environ.get("DB_PORT", os.environ.get("port", "3306")))
except Exception:
    port = 3306

try:
    c = pymysql.connect(host=host, user=user, password=password, port=port, connect_timeout=2)
    c.close()
    sys.exit(0)
except Exception:
    sys.exit(1)
PY
  rc=$?
  if [ "$rc" -eq 0 ]; then
    echo "MariaDB ready."
    break
  fi
  echo "DB not ready - sleeping 2s"
  sleep 2
done

if [ $# -gt 0 ]; then
  exec "$@"
else
  exec /bin/bash
fi
