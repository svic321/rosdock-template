#!/usr/bin/env bash
# Runs on the HOST before the container is created (devcontainer "initializeCommand").
# Generates a wildcard-family Xauthority cookie so GUI apps started via
# `docker exec` (not just the VS Code integrated terminal) can reach the host's X server.
set -uo pipefail

XAUTH_FILE="$HOME/.devcontainer.xauth"
touch "$XAUTH_FILE"

if command -v xauth >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
  xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH_FILE" nmerge - 2>/dev/null
else
  echo "init-xauth: xauth not found or DISPLAY unset, GUI apps in the container may fail" >&2
fi
