#!/usr/bin/env bash
set -euo pipefail

# Ir a la raiz del repo (el script vive en scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

# Activa venv si existe
if [ -f ".venv/bin/activate" ]; then
  # shellcheck disable=SC1091
  source ".venv/bin/activate"
fi

if ! command -v python >/dev/null 2>&1; then
  echo "ERROR: no se encontro 'python' en PATH. Ejecuta primero scripts/ec2_setup.sh."
  exit 1
fi

PORT="${PORT:-8501}"
ADDR="${ADDR:-0.0.0.0}"

echo "Arrancando Streamlit en segundo plano en ${ADDR}:${PORT} ..."
nohup python -m streamlit run app/dashboard.py \
  --server.address "${ADDR}" \
  --server.port "${PORT}" \
  > "${REPO_ROOT}/streamlit.log" 2>&1 &

echo "OK. PID: $!"
echo "Revisa logs con: tail -f ${REPO_ROOT}/streamlit.log"
echo "Abre: http://IP_PUBLICA_EC2:${PORT}"
