#!/bin/bash

set -euo pipefail

BASE_URL="${PISTON_URL:-http://localhost:2000}"

echo "==> Query installed runtimes"
curl -fsS "${BASE_URL}/api/v2/runtimes"
echo

if curl -fsS "${BASE_URL}/api/v2/runtimes" | grep -q '"language":"python"'; then
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
