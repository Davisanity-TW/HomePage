#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPORTS="$ROOT_DIR/exports"
ARCHIVES="$ROOT_DIR/archives"

mkdir -p "$EXPORTS" "$ARCHIVES"

cd /home/ubuntu/clawd

# 1) Export status / versions
clawdbot status --all > "$EXPORTS/clawdbot_status.txt"
node -v > "$EXPORTS/versions.txt"
echo "pnpm: $(pnpm -v 2>/dev/null || echo N/A)" >> "$EXPORTS/versions.txt"
echo "clawdbot: $(clawdbot --version 2>/dev/null || echo N/A)" >> "$EXPORTS/versions.txt"

# 2) Export cron jobs (JSON)
clawdbot cron list --all --json > "$EXPORTS/cron_jobs.json"

# 3) Export user systemd unit
(systemctl --user status clawdbot-gateway.service --no-pager || true) > "$EXPORTS/systemd_gateway_status.txt"
(systemctl --user cat clawdbot-gateway.service --no-pager || true) > "$EXPORTS/systemd_gateway_unit.txt"

# 4) Workspace manifests
( cd /home/ubuntu/clawd && ls -la ) > "$EXPORTS/workspace_ls.txt"
( cd /home/ubuntu/clawd && find . -maxdepth 2 -type f \( -name "*.sh" -o -name "*.py" -o -name "*.mjs" -o -name "*.js" -o -name "Dockerfile" -o -name "docker-compose.yml" \) -print ) > "$EXPORTS/workspace_programs_manifest.txt"

# 5) Build tarball (includes secrets), then encrypt
TMP_TGZ="/tmp/clawdbot_backup.tgz"
ENC_OUT="$ARCHIVES/clawdbot_backup.tgz.enc"

# Avoid recursive capture of this HomePage repo backup itself
# Exclude heavy folders
sudo -n true 2>/dev/null || true

tar -czf "$TMP_TGZ" \
  --exclude='**/node_modules' \
  --exclude='**/.venv' \
  --exclude='**/__pycache__' \
  --exclude='**/.pytest_cache' \
  --exclude='**/.mypy_cache' \
  --exclude='/home/ubuntu/clawd/HomePage' \
  /home/ubuntu/.clawdbot \
  /home/ubuntu/clawd

# Encrypt (AES-256-CBC, PBKDF2)
# Prompts for password (do not store it in repo)
openssl enc -aes-256-cbc -pbkdf2 -iter 200000 -salt \
  -in "$TMP_TGZ" -out "$ENC_OUT"

rm -f "$TMP_TGZ"

echo "OK: wrote $ENC_OUT"
