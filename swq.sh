#!/bin/bash
set -e

URL="https://swnonsolo.vercel.app/"

echo "====================================================="
echo "Membuka $URL dengan Chrome (Stealth Headless)"
echo "====================================================="

# Fix hostname warning
echo "127.0.0.1 $(hostname)" >> /etc/hosts || true

# Dependencies
apt-get update -qq
apt-get install -y -qq wget gnupg ca-certificates xvfb

# Add Chrome repo
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
  | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] \
http://dl.google.com/linux/chrome/deb/ stable main" \
> /etc/apt/sources.list.d/google-chrome.list

apt-get update -qq
apt-get install -y -qq google-chrome-stable

google-chrome --version

# Xvfb
export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset >/dev/null 2>&1 &
sleep 3

export NO_AT_BRIDGE=1
export DBUS_SESSION_BUS_ADDRESS="disabled:"

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-blink-features=AutomationControlled \
  --window-size=1920,1080 \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36" \
  --lang=en-US,en \
  "$URL" &

PID=$!
echo "Chrome PID: $PID"
echo "Website dibuka."

while kill -0 $PID 2>/dev/null; do
  echo "[$(date)] Chrome running..."
  sleep 60
done
