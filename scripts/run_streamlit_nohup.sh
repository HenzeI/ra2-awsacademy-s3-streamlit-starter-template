#!/usr/bin/env bash
set -euo pipefail

# Ir al directorio del script
cd "$(dirname "$0")"

# Activa venv si existe
if [ -f ".venv/bin/activate" ]; then
  # shellcheck disable=SC1091
  source ".venv/bin/activate"
fi

PORT="${PORT:-8501}"
ADDR="${ADDR:-0.0.0.0}"

echo "Arrancando Streamlit en segundo plano en ${ADDR}:${PORT} ..."
nohup python -m streamlit run app/dashboard.py \
  --server.address "${ADDR}" \
  --server.port "${PORT}" \
  > streamlit.log 2>&1 &

echo "OK. PID: $!"
echo "Revisa logs con: tail -f streamlit.log"
echo "Abre: http://IP_PUBLICA_EC2:${PORT}"