#!/usr/bin/env bash
# Start EasyPaper on port 8004 (for AgentSociety2 integration).
# API base: http://localhost:8004

set -e
cd "$(dirname "$0")"

PORT="${EASYPAPER_PORT:-8004}"
CONFIG="${AGENT_CONFIG_PATH:-./configs/example.yaml}"

# Ensure EasyPaper uses the desired config
export AGENT_CONFIG_PATH="$CONFIG"
# Internal agent calls (Typesetter, Reviewer, Planner, VLM) must target this server
export EASYPAPER_BASE_URL="http://127.0.0.1:$PORT"

echo "Starting EasyPaper on port $PORT (config: $CONFIG)"
echo "  Health:     http://localhost:$PORT/healthz"
echo "  Generate:   POST http://localhost:$PORT/metadata/generate"
echo "  Typesetter: POST http://localhost:$PORT/agent/typesetter/compile"
echo ""

# Prefer venv uvicorn if available
if [ -x ".venv/bin/uvicorn" ]; then
  UVICORN_BIN=".venv/bin/uvicorn"
else
  UVICORN_BIN="uvicorn"
fi

exec "$UVICORN_BIN" src.main:app --host 0.0.0.0 --port "$PORT"
