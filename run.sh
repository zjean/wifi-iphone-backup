#!/bin/bash

# Build the Docker image
docker build . -t zjean/wifi-iphone-backup && \

# Stop and remove any existing container
docker stop wifi-iphone-backup || true && \
docker rm wifi-iphone-backup || true && \

mkdir -p ./bin
mkdir -p ./logs
mkdir -p ./data

# Run the container
sudo docker run -d \
  -v "./logs:/app/logs" \
  -v "./bin:/app/bin" \
  -v "./data:/data" \
  -v "/dev/bus/usb:/dev/bus/usb" \
  -v "/var/lib/lockdown:/var/lib/lockdown" \
  -v "/var/run:/var/run" \
  -v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
  --name wifi-iphone-backup \
  --network host \
  --privileged \
  zjean/wifi-iphone-backup
