#!/bin/bash

set -e

echo ">>> Menambahkan GPG key NodeSource..."
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg

echo ">>> Menambahkan repository Node.js 18 ke sources.list.d..."
echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x bionic main" | sudo tee /etc/apt/sources.list.d/nodesource.list

echo ">>> Update apt dan install Node.js + npm..."
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y nodejs

echo ">>> Instalasi selesai. Cek versi:"
node -v
npm -v
