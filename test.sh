#!/bin/bash

set -euo pipefail

BASE_URL="${PISTON_URL:-http://localhost:2000}"
RUNTIMES_FILE="$(mktemp)"
trap 'rm -f "${RUNTIMES_FILE}"' EXIT

echo "==> Checking Piston API availability: ${BASE_URL}"
HTTP_CODE="$(curl -sS -o "${RUNTIMES_FILE}" -w '%{http_code}' "${BASE_URL}/api/v2/runtimes")"

if [ "${HTTP_CODE}" != "200" ]; then
	echo "Piston API check failed: HTTP ${HTTP_CODE}"
	exit 1
fi

if ! grep -q '^\[' "${RUNTIMES_FILE}"; then
	echo "Unexpected runtimes response (expected JSON array):"
	cat "${RUNTIMES_FILE}"
	exit 1
fi

echo "Piston API is healthy. Runtimes endpoint returned a JSON array."
