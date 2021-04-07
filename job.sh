#!/bin/bash
source /etc/profile

hostname

source activate denovo_asm

# if parameter passed in this will be where we execute the job

if [ -z $1 ]; then
  # cd to input directory
  cd /data/input
  WORKDIR=$RANDOM
else
  mkdir -p /data/input/$1
  cd /data/input/$1
  WORKDIR=$1
fi

if [ -z $2 ]; then
  # Set some default if nothing was passed in
  GENOME_SIZE=4m
else
  GENOME_SIZE=$2
fi

# report what is in the input area for debuggin
ls -la

# Only fastq files are processed
FASTQ_FILES=$(find . -name '*.fastq' -not -type d | tr '\n' ' ')
echo $FASTQ_FILES
      
NOW=$(date +'%m%d%Y-%H%M%S')

time canu \
 -p $WORKDIR -d /data/runs/$1/RUN \
 genomeSize=$GENOME_SIZE \
 -pacbio $FASTQ_FILES 2>&1 | tee /data/runs/$1/run-$NOW.log

