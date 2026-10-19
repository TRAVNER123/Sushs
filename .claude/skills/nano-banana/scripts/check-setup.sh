#!/usr/bin/env bash
# Verify the Gemini CLI, the nanobanana extension, and an API key are available.
# Exits non-zero if anything is missing, printing the fix for each problem.

status=0

if command -v gemini >/dev/null 2>&1; then
  echo "ok: gemini CLI found ($(command -v gemini))"
else
  echo "missing: gemini CLI. Install with: npm install -g @google/gemini-cli"
  status=1
fi

if [ "$status" -eq 0 ]; then
  if gemini extensions list 2>/dev/null | grep -qi nanobanana; then
    echo "ok: nanobanana extension installed"
  else
    echo "missing: nanobanana extension. Install with:"
    echo "  gemini extensions install https://github.com/gemini-cli-extensions/nanobanana"
    status=1
  fi
fi

# The extension checks these variables in this order.
key_var=""
for var in NANOBANANA_API_KEY NANOBANANA_GEMINI_API_KEY NANOBANANA_GOOGLE_API_KEY GEMINI_API_KEY GOOGLE_API_KEY; do
  if [ -n "${!var}" ]; then
    key_var="$var"
    break
  fi
done
if [ -n "$key_var" ]; then
  echo "ok: API key found in \$$key_var"
else
  echo "missing: API key. Get one at https://aistudio.google.com/apikey, then:"
  echo "  export NANOBANANA_API_KEY=\"your-api-key\""
  status=1
fi

echo "model: ${NANOBANANA_MODEL:-gemini-3.1-flash-image-preview (default)}"
exit "$status"
