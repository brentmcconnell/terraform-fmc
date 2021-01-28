#!/bin/bash -x

source activate denovo_asm

# cd to input directory
cd /data/input

# report what is in the input area for debuggin
ls -la

FASTQ_FILES=$(find . -name '*.fastq' -maxdepth 1 -not -type d | tr '\n' ' ')
echo $FASTQ_FILES

time canu \
 -p ecoli -d /data/assembly/RUN \
 genomeSize=4.8m \
 -pacbio $FASTQ_FILES | tee /data/input/run.log

# # check to see if file already exists and delete
# if [ -f /data/input/DRR213641 ]; then
#   echo "Removing existing file"
#   rm /data/input/DRR213641
# fi

# # check to see if file already exists and delete
# if [ -f /data/input/DRR213641.fastq ]; then
#   echo "Removing existing fastq file"
#   rm /data/input/DRR213641.fastq
# fi

# wget -nv https://sra-download.ncbi.nlm.nih.gov/traces/dra4/DRR/000208/DRR213641 -P /data/input

# fasterq-dump /data/input/DRR213641 -O /data/input

# time canu -p RKN -d /data/assembly/RKN_canu \
#   genomeSize=0.2g corMhapFilterThreshold=0.0000000002 \
#   mhapMemory=60g mhapBlockSize=500 \
#   ovlMerDistinct=0.975 \
#   corMhapOptions="--threshold 0.80 --num-hashes 512 --num-min-matches 3 --ordered-sketch-size 1000 --ordered-kmer-size 14 --min-olap-length 2000 --repeat-idf-scale 50" \
#   -pacbio-raw /data/input/DRR213641.fastq > RKN.out 2> RKN.err
