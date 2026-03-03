#!/bin/bash

set -euo pipefail

BASE_URL="${PISTON_URL:-http://localhost:2000}"
RUNTIMES_FILE="$(mktemp)"
trap 'rm -f "${RUNTIMES_FILE}"' EXIT

echo "==> Query installed runtimes"
curl -fsS "${BASE_URL}/api/v2/runtimes" | tee "${RUNTIMES_FILE}"
echo

if grep -q '"language":"bash"' "${RUNTIMES_FILE}"; then
	echo "==> Execute Bash example"
	curl -fsS -X POST "${BASE_URL}/api/v2/execute" \
		-H 'Content-Type: application/json' \
		-d '{
			"language": "bash",
			"version": "*",
			"files": [{"name": "main.sh", "content": "echo Hello from Piston Bash on Ubuntu 24.04"}],
			"stdin": ""
		}'
	echo
else
	echo "bash runtime not installed yet. Install runtimes into /piston/packages first."
fi
