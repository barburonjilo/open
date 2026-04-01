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
