#!/bin/bash
conda init bash
conda create --yes -n denovo_asm

# This section prepares the large /data disk area
if ! [ -d /data/input ]; then
  echo "Creating /data/input"
  mkdir -p /data/input
fi
if ! [ -d /data/runs ]; then
  echo "Creating /data/runs"
  mkdir -p /data/runs
fi

