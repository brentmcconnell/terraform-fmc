#!/bin/bash
exit 0
conda init bash
conda create --yes -n denovo_asm
conda activate denovo_asm
cd /data/input
wget -nv https://sra-download.ncbi.nlm.nih.gov/traces/dra4/DRR/000208/DRR213641

# check to see if file already exists and delete
if [ -f ./DRR213641 ]; then
  echo "Removing existing file"
  rm ./DRR213641
fi

# check to see if file already exists and delete
if [ -f ./DRR213641.fastq ]; then
  echo "Removing existing fastq file"
  rm ./DRR213641.fastq
fi

fasterq-dump ./DRR213641

time canu -p RKN -d /data/assembly/RKN_canu genomeSize=0.2g corMhapFilterThreshold=0.0000000002 corMhapOptions="--threshold 0.80 --num-hashes 512 --num-min-matches 3 --ordered-sketch-size 1000 --ordered-kmer-size 14 --min-olap-length 2000 --repeat-idf-scale 50" mhapMemory=60g mhapBlockSize=500 ovlMerDistinct=0.975 -pacbio-raw /data/input/DRR213641.fastq > RKN.out 2> RKN.err
