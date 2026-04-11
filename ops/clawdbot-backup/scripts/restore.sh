#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVES="$ROOT_DIR/archives"
EXPORTS="$ROOT_DIR/exports"

ENC_IN="$ARCHIVES/clawdbot_backup.tgz.enc"
PART_PREFIX="$ARCHIVES/clawdbot_backup.tgz.enc.part-"
TMP_TGZ="/tmp/clawdbot_backup.tgz"

if [ ! -f "$ENC_IN" ]; then
  echo "ERROR: missing $ENC_IN" >&2
  exit 1
fi

echo "== Decrypt archive =="
# will prompt for password
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in "$ENC_IN" -out "$TMP_TGZ"

echo "== Extract to / =="
# Extract absolute paths as saved by tar
sudo tar -xzf "$TMP_TGZ" -C /
rm -f "$TMP_TGZ"

# Permissions hardening (best-effort)
chmod 700 /home/ubuntu/.clawdbot 2>/dev/null || true
chmod 600 /home/ubuntu/.clawdbot/clawdbot.json 2>/dev/null || true

echo "== Ensure gateway user service enabled + restarted =="
# user systemd unit
systemctl --user daemon-reload || true
systemctl --user enable clawdbot-gateway.service || true
systemctl --user restart clawdbot-gateway.service || true

echo "== Import cron jobs into new gateway =="
# Requires clawdbot CLI and gateway reachable
if command -v clawdbot >/dev/null 2>&1; then
  python3 "$(dirname "$0")/apply_cron_jobs.py" || true
else
  echo "WARN: clawdbot CLI not found. Install it first, then restore cron jobs." >&2
fi

echo "== Done =="

echo "Next checks:"
echo "  clawdbot status"
echo "  clawdbot cron list --all"
echo "  systemctl --user status clawdbot-gateway.service --no-pager"
