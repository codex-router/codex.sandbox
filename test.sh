#!/bin/bash

set -euo pipefail

BASE_URL="${PISTON_URL:-http://localhost:2000}"

echo "==> Checking Piston API availability: ${BASE_URL}"
HTTP_CODE="$(curl -sS -o /tmp/piston_runtimes.json -w '%{http_code}' "${BASE_URL}/api/v2/runtimes")"

if [ "${HTTP_CODE}" != "200" ]; then
	echo "Piston API check failed: HTTP ${HTTP_CODE}"
	exit 1
fi

if ! grep -q '^\[' /tmp/piston_runtimes.json; then
	echo "Unexpected runtimes response (expected JSON array):"
	cat /tmp/piston_runtimes.json
	exit 1
fi

echo "Piston API is healthy. Runtimes endpoint returned a JSON array."
