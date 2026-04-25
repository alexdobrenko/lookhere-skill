#!/usr/bin/env bash
# publish.sh - Publish JSON to lookhere and print the URL
#
# Usage:
#   bash scripts/publish.sh '{"mode":"doc","title":"My Page","text":"## Hello\n\nBody."}'
#   bash scripts/publish.sh "$(cat payload.json)"
#
# Outputs the live URL to stdout. Copies to clipboard if pbcopy is available.

set -euo pipefail

LOOKHERE_URL="https://lookhere.alex-dobrenko.workers.dev"

if [[ $# -eq 0 ]]; then
  echo "Usage: bash scripts/publish.sh '<json payload>'" >&2
  echo "   or: bash scripts/publish.sh \"\$(cat payload.json)\"" >&2
  exit 1
fi

PAYLOAD="$1"

# Validate it's JSON before sending
if ! echo "$PAYLOAD" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
  echo "Error: payload is not valid JSON" >&2
  exit 1
fi

if ! RESULT=$(curl -s --max-time 30 -X POST \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" \
  "$LOOKHERE_URL/api/publish"); then
  echo "Error: could not reach $LOOKHERE_URL (network down or timeout)" >&2
  exit 1
fi

# Check for error in response
if echo "$RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); exit(0 if 'url' in d else 1)" 2>/dev/null; then
  URL=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['url'])")
  EXPIRES=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['expires_at'][:10])")
  echo "$URL"
  echo "(expires $EXPIRES)" >&2
  # Copy to clipboard if available (mac, linux x11, linux wayland)
  if command -v pbcopy &>/dev/null; then
    echo -n "$URL" | pbcopy
    echo "Copied to clipboard." >&2
  elif command -v xclip &>/dev/null; then
    echo -n "$URL" | xclip -selection clipboard
    echo "Copied to clipboard." >&2
  elif command -v wl-copy &>/dev/null; then
    echo -n "$URL" | wl-copy
    echo "Copied to clipboard." >&2
  else
    echo "(no clipboard tool found, install xclip or wl-clipboard if you want auto-copy)" >&2
  fi
else
  echo "Error from server:" >&2
  echo "$RESULT" >&2
  exit 1
fi
