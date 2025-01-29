#!/bin/bash

# Build the Docker image
docker build . -t libimobiledevice-docker && \

# Stop and remove any existing container
docker stop libimobiledevice-docker || true && \
docker rm libimobiledevice-docker || true && \

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
  --name libimobiledevice-docker \
  --network host \
  --privileged \
  libimobiledevice-docker
