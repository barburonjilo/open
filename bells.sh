# Install necessary packages
sudo apt update
sudo apt install -y docker.io npm 

# Clone the repository into a directory
git clone https://github.com/oneevil/stratum-ethproxy bell

for i in {1..10}; do
  # Set up and start each 'cpu' instance
  cd bell
  npm install
  # stratum.vecocoin.com:8602
  # pool.rwinfo.club:6533
  # stratum-mining-pool.zapto.org:3725
  # Set environment variables for 'cpu'
  LOCAL_IP=$(hostname -I | awk '{print $1}')
  cat <<EOL > .env
REMOTE_HOST=nomp.mofumofu.me
REMOTE_PORT=3351
REMOTE_PASSWORD=x
LOCAL_HOST=$LOCAL_IP
LOCAL_PORT=$((442 + i))
EOL

  # Start the stratum-ethproxy in a detached screen session with a specific name
  sudo screen -dmS bell_$i npm start

  # Check if screen session was created successfully
  if [ $? -eq 0 ]; then
    echo "Started screen session bell_$i successfully."
  else
    echo "Failed to start screen session bell_$i."
  fi
  
  # Navigate back to the parent directory
  cd ..
done
