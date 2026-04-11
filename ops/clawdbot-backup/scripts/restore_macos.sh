#!/usr/bin/env bash
set -euo pipefail

# Restores this backup on macOS.
# Notes:
# - Linux absolute paths inside the tarball cannot be extracted 1:1 on macOS.
# - We restore into:
#     ~/.clawdbot
#     ~/clawd
#   and then you run clawdbot from ~/clawd.

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "ERROR: This script is for macOS only." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVES="$ROOT_DIR/archives"
EXPORTS="$ROOT_DIR/exports"

ENC_OUT="$ARCHIVES/clawdbot_backup.tgz.enc"
PART_PREFIX="$ARCHIVES/clawdbot_backup.tgz.enc.part-"
TMP_TGZ="/tmp/clawdbot_backup.tgz"

# 1) Assemble parts if needed
if [[ ! -f "$ENC_OUT" ]]; then
  if ls "$PART_PREFIX"* >/dev/null 2>&1; then
    echo "== Assembling encrypted archive from parts =="
    cat "$PART_PREFIX"* > "$ENC_OUT"
  fi
fi

if [[ ! -f "$ENC_OUT" ]]; then
  echo "ERROR: missing encrypted archive. Expected $ENC_OUT or ${PART_PREFIX}*" >&2
  exit 1
fi

# 2) Decrypt
echo "== Decrypt archive (will prompt for password) =="
# Prefer brew openssl if present
if command -v openssl >/dev/null 2>&1; then
  OPENSSL=openssl
elif [[ -x "$(brew --prefix openssl@3 2>/dev/null)/bin/openssl" ]]; then
  OPENSSL="$(brew --prefix openssl@3)/bin/openssl"
else
  echo "ERROR: openssl not found. Run init_macos.sh first." >&2
  exit 1
fi

"$OPENSSL" enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in "$ENC_OUT" -out "$TMP_TGZ"

# 3) Extract selective content (map linux paths -> mac home)
RESTORE_HOME="$HOME"
RESTORE_CLAWD="$HOME/clawd"
RESTORE_CLAWDBOT="$HOME/.clawdbot"

mkdir -p "$RESTORE_CLAWD" "$RESTORE_CLAWDBOT"

echo "== Extracting backup into $HOME =="
# Extract to a staging dir then copy what we want
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE" "$TMP_TGZ"' EXIT

tar -xzf "$TMP_TGZ" -C "$STAGE"

# The tarball contains paths like: home/ubuntu/.clawdbot and home/ubuntu/clawd
if [[ -d "$STAGE/home/ubuntu/.clawdbot" ]]; then
  rsync -a --delete "$STAGE/home/ubuntu/.clawdbot/" "$RESTORE_CLAWDBOT/"
else
  echo "WARN: .clawdbot not found in archive staging." >&2
fi

if [[ -d "$STAGE/home/ubuntu/clawd" ]]; then
  rsync -a --delete \
    --exclude 'HomePage' \
    --exclude 'node_modules' \
    "$STAGE/home/ubuntu/clawd/" "$RESTORE_CLAWD/"
else
  echo "WARN: clawd workspace not found in archive staging." >&2
fi

chmod 700 "$RESTORE_CLAWDBOT" || true
chmod 600 "$RESTORE_CLAWDBOT/clawdbot.json" 2>/dev/null || true

# 4) Start gateway (foreground) and apply cron jobs
# On macOS we typically run gateway as a background process or LaunchAgent.

echo "== Starting Clawdbot gateway (background) =="
# Try to start gateway as a background process (best-effort)
# If your clawdbot has different gateway subcommands, run `clawdbot gateway --help`.
(clawdbot gateway start >/dev/null 2>&1 || true)

echo "== Applying cron jobs =="
python3 "$(dirname "$0")/apply_cron_jobs.py" || true

cat <<TXT

OK: restore finished.

Workspace:
  $RESTORE_CLAWD
Config:
  $RESTORE_CLAWDBOT

Next checks:
  clawdbot status
  clawdbot cron list --all

If gateway didn't start automatically, run:
  clawdbot gateway start
  clawdbot gateway status
TXT
