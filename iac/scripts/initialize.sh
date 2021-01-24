#!/bin/bash

# Check if user exists
if ! id -u azureuser > /dev/null 2>&1; then
  useradd azureuser
fi

if ! [ -d /home/azureuser/.ncbi ]; then
  mkdir -p /home/azureuser/.ncbi
fi

cat << EOF > /home/azureuser/.ncbi/user-settings.mkfg
/LIBS/GUID = "35a9977e-ac83-4b06-8751-ea61537984a7"
/config/default = "false"
/repository/user/ad/public/apps/file/volumes/flatAd = "."
/repository/user/ad/public/apps/refseq/volumes/refseqAd = "."
/repository/user/ad/public/apps/sra/volumes/sraAd = "."
/repository/user/ad/public/apps/sraPileup/volumes/ad = "."
/repository/user/ad/public/apps/sraRealign/volumes/ad = "."
/repository/user/ad/public/root = "."
/repository/user/default-path = "/home/azureuser/ncbi"
EOF

chown -R azureuser:azureuser /home/azureuser

if ! [ -d /data/input ]; then
  mkdir -p /data/input
fi
if ! [ -d /data/runs ]; then
  mkdir -p /data/runs
fi

chown -R azureuser:azureuser /data
