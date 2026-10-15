#!/usr/bin/env sh
set -eu

: "${API_BASE_URL:?Set API_BASE_URL}"
: "${API_KEY:?Set API_KEY}"

curl --fail-with-body --silent --show-error \
  -X POST "${API_BASE_URL}/v1/discovery/jobs" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: demo-discovery-job-001" \
  --data @examples/discovery-job.json
