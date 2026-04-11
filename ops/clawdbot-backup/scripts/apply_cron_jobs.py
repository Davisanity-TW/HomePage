#!/usr/bin/env python3
import json, os, shlex, subprocess, sys

EXPORTS = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "exports"))
CRON_JSON = os.path.join(EXPORTS, "cron_jobs.json")

if not os.path.exists(CRON_JSON):
    print(f"ERROR: missing {CRON_JSON}", file=sys.stderr)
    sys.exit(1)

data = json.load(open(CRON_JSON, "r", encoding="utf-8"))
jobs = data.get("jobs", [])

if not jobs:
    print("No jobs in cron_jobs.json")
    sys.exit(0)

created = 0
failed = 0

for j in jobs:
    name = j.get("name") or "(unnamed)"
    agent = j.get("agentId") or "main"
    enabled = bool(j.get("enabled", True))
    session = j.get("sessionTarget", "main")
    wake = j.get("wakeMode", "next-heartbeat")

    sched = j.get("schedule", {})
    kind = sched.get("kind")

    payload = j.get("payload", {})
    msg = payload.get("message")
    deliver = bool(payload.get("deliver", False))
    channel = payload.get("channel", "last")
    to = payload.get("to")

    if kind != "cron":
        print(f"SKIP (unsupported schedule kind={kind}): {name}")
        continue

    expr = sched.get("expr")
    tz = sched.get("tz") or ""

    if not expr or not msg:
        print(f"SKIP (missing expr/message): {name}")
        continue

    cmd = [
        "clawdbot", "cron", "add",
        "--name", name,
        "--agent", agent,
        "--session", session,
        "--wake", wake,
        "--cron", expr,
    ]

    if tz:
        cmd += ["--tz", tz]

    if not enabled:
        cmd += ["--disabled"]

    # payload
    cmd += ["--message", msg]

    if deliver:
        cmd += ["--deliver", "--channel", channel]
        if to:
            cmd += ["--to", str(to)]

    print("APPLY:", " ".join(shlex.quote(x) for x in cmd))
    try:
        subprocess.check_call(cmd)
        created += 1
    except subprocess.CalledProcessError as e:
        failed += 1
        print(f"ERROR: failed to apply job: {name} ({e})", file=sys.stderr)

print(f"Done. created={created} failed={failed}")
if failed:
    sys.exit(2)
