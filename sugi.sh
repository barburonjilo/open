# Install necessary packages
sudo apt update
sudo apt install -y docker.io npm 

# Clone the repository into a directory
git clone https://github.com/oneevil/stratum-ethproxy mun

for i in {1..10}; do
  # Set up and start each 'cpu' instance
  cd mun
  npm install
  
  # Set environment variables for 'cpu'
  LOCAL_IP=$(hostname -I | awk '{print $1}')
  cat <<EOL > .env
REMOTE_HOST=yespowerSUGAR.asia.mine.zergpool.com
REMOTE_PORT=6535
REMOTE_PASSWORD=x
LOCAL_HOST=$LOCAL_IP
LOCAL_PORT=$((500 + i))
EOL

  # Start the stratum-ethproxy in a detached screen session with a specific name
  sudo screen -dmS mun_$i npm start

  # Check if screen session was created successfully
  if [ $? -eq 0 ]; then
    echo "Started screen session mun_$i successfully."
  else
    echo "Failed to start screen session mun_$i."
  fi
  
  # Navigate back to the parent directory
  cd ..
done
