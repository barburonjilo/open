#!/bin/bash

URL="https://swnonsolo.vercel.app/"  # Ganti kalau perlu

echo "====================================================="
echo "Membuka $URL dengan Chrome (bypass detection enhanced)"
echo "====================================================="

sudo apt-get update -qq
sudo apt-get install -y -qq google-chrome-stable xvfb

google-chrome --version

export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset > /dev/null 2>&1 &
echo "Xvfb started"
sleep 5

# Suppress harmless warnings
export NO_AT_BRIDGE=1
export DBUS_SESSION_BUS_ADDRESS="disabled:"

google-chrome \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --window-size=1920,1080 \
  --start-maximized \
  --ignore-certificate-errors \
  --allow-insecure-localhost \
  --disable-web-security \
  --no-first-run \
  --no-default-browser-check \
  --disable-blink-features=AutomationControlled \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36" \
  --lang=en-US,en \
  --enable-webgl \
  "$URL" &

CHROME_PID=$!
echo "Chrome PID: $CHROME_PID"
echo "Website dibuka. Tunggu 1-2 menit."

while true; do
    sleep 60
    if ! kill -0 $CHROME_PID 2>/dev/null; then
        echo "Chrome mati."
        exit 1
    fi
    echo "[$(date)] Chrome masih jalan (PID: $CHROME_PID)"
done
