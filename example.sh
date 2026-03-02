#!/bin/bash

set -euo pipefail

BASE_URL="${PISTON_URL:-http://localhost:2000}"
RUNTIMES_FILE="$(mktemp)"
trap 'rm -f "${RUNTIMES_FILE}"' EXIT

echo "==> Query installed runtimes"
curl -fsS "${BASE_URL}/api/v2/runtimes" | tee "${RUNTIMES_FILE}"
echo

if grep -q '"language":"python"' "${RUNTIMES_FILE}"; then
	echo "==> Execute Python example"
	curl -fsS -X POST "${BASE_URL}/api/v2/execute" \
		-H 'Content-Type: application/json' \
		-d '{
			"language": "python",
			"version": "*",
			"files": [{"name": "main.py", "content": "print(\"Hello from Piston on Ubuntu 24.04\")"}],
			"stdin": ""
		}'
	echo
else
	echo "python runtime not installed yet. Install runtimes into /piston/packages first."
fi
