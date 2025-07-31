#!/bin/bash

# === Update & Install Dependencies ===
echo "[INFO] Memperbarui dan menginstal dependensi..."

sudo dnf update -y
sudo dnf install -y docker git curl tar

# Install Node.js dan npm (gunakan n jika perlu versi terbaru)
if ! command -v npm &> /dev/null; then
  echo "[INFO] Menginstal Node.js dan npm..."
  curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
  sudo dnf install -y nodejs
fi

# === Clone repo ===
echo "[INFO] Mengkloning repository..."
git clone https://github.com/oneevil/stratum-ethproxy vec

# === Jalankan 10 instance ===
for i in {1..10}; do
  echo "[INFO] Menyiapkan instance ke-$i..."

  cd vec || { echo "[ERROR] Folder vec tidak ditemukan!"; exit 1; }

  # Install dependencies
  npm install

  # Ambil IP lokal (gunakan `hostname -I` jika tersedia, fallback ke `hostname -i`)
  LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
  if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP=$(hostname -i)
  fi

  # Buat file .env
  cat <<EOL > .env
REMOTE_HOST=stratum.vecocoin.com
REMOTE_PORT=8602
REMOTE_PASSWORD=x
LOCAL_HOST=$LOCAL_IP
LOCAL_PORT=$((442 + i))
EOL

  # Jalankan proxy dalam screen session
  LOG_FILE="../vec_instance_$i.log"
  nohup npm start > "$LOG_FILE" 2>&1 &

  # Cek status
  if [ $? -eq 0 ]; then
    echo "[SUCCESS] Instance ke-$i berjalan di background. Log: $LOG_FILE"
  else
    echo "[FAIL] Gagal menjalankan instance ke-$i"
  fi

  cd ..
done
