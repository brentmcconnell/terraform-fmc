#!/bin/bash
hostname
conda init bash
conda create --yes -n denovo_asm

# This section prepares the large /data disk area
if ! [ -d /data/input/$1 ]; then
  echo "Creating /data/input"
  mkdir -p /data/input/$1
fi
if ! [ -d /data/runs/$1 ]; then
  echo "Creating /data/runs"
  mkdir -p /data/runs/$1
fi

