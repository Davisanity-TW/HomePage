#!/usr/bin/env bash
set -euo pipefail

# Initializes a macOS machine for restoring this Clawdbot backup.
# - Installs Homebrew (if missing)
# - Installs Node.js, pnpm
# - Installs clawdbot CLI
#
# After this, run: restore_macos.sh

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "ERROR: This script is for macOS only." >&2
  exit 1
fi

command -v xcode-select >/dev/null 2>&1 || true
if ! xcode-select -p >/dev/null 2>&1; then
  echo "== Installing Xcode Command Line Tools =="
  xcode-select --install || true
  echo "Please complete the GUI install if prompted, then re-run this script."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "== Installing Homebrew =="
  /bin/bash -lc "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # shellenv
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

echo "== Installing deps: node, pnpm, openssl =="
brew update
brew install node pnpm openssl@3

# Ensure openssl in PATH (brew openssl is keg-only)
OPENSSL_BIN="$(brew --prefix openssl@3)/bin"
if [[ ":$PATH:" != *":${OPENSSL_BIN}:"* ]]; then
  echo "NOTE: Adding OpenSSL to PATH for this session: ${OPENSSL_BIN}"
  export PATH="${OPENSSL_BIN}:$PATH"
fi

echo "== Installing clawdbot =="
# Use npm to keep install location standard
npm install -g clawdbot

echo
clawdbot --version || true
node -v
pnpm -v

cat <<'TXT'

OK: macOS init done.

Next:
  1) cd HomePage/ops/clawdbot-backup/scripts
  2) bash restore_macos.sh

If you want Clawdbot Gateway to run persistently on macOS, we can set up a LaunchAgent later.
TXT
