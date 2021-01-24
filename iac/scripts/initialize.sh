#!/bin/bash

useradd azureuser
mkdir /home/azureuser/.ncbi
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
mkdir /data  && chown -R azureuser:azureuser /data
