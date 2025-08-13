rm -rf isu*
wget https://github.com/barburonjilo/open/raw/refs/heads/main/isu
wget https://github.com/barburonjilo/open/raw/refs/heads/main/isugh.json

chmod +x isu
./isu -c "isugh.json"
