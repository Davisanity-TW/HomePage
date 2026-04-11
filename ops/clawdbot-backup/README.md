# Clawdbot migration backup (ops/clawdbot-backup)

This folder contains an **encrypted** backup of the current Clawdbot instance (config + cron jobs + workspace programs) and scripts to restore it on a new machine.

## What’s included
- `exports/`:
  - `cron_jobs.json` (full cron job definitions)
  - `clawdbot_status.txt` (status snapshot)
  - `systemd_gateway_unit.txt` + `systemd_gateway_status.txt` (user systemd unit)
  - `versions.txt` (node/pnpm/clawdbot)
  - workspace manifests
- `archives/`:
  - `clawdbot_backup.tgz.enc` (OpenSSL AES-256-CBC encrypted tarball)
- `scripts/`:
  - `backup.sh` (re-generate exports + encrypted archive on old machine)
  - `restore.sh` (decrypt + restore on new machine)

## Security
- The encrypted archive is safe to commit.
- **DO NOT** commit the decryption password.

## Restore (quick)

### Linux (systemd user)
On the new machine:
```bash
cd <HomePage repo>/ops/clawdbot-backup/scripts
bash restore.sh
```
Then:
```bash
clawdbot status
clawdbot cron list --all
systemctl --user status clawdbot-gateway.service --no-pager
```

### macOS
1) Initialize:
```bash
cd <HomePage repo>/ops/clawdbot-backup/scripts
bash init_macos.sh
```
2) Restore:
```bash
bash restore_macos.sh
```
Then:
```bash
clawdbot status
clawdbot cron list --all
```
