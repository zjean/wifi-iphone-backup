FROM debian:bookworm-slim

# Set the working directory
WORKDIR /app

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libavahi-compat-libdnssd-dev \
    libusb-1.0-0-dev \
    libclang-dev \
    libusbmuxd-dev \
    libimobiledevice-utils \
    ideviceinstaller \
    usbmuxd \
    avahi-daemon \
    avahi-utils \
    libnss-mdns \
    avahi-discover \
    curl \
    screen \
    dbus \
    jq \
    supervisor \
    xz-utils \
    && apt-get clean

# Copy the altserver directory to the container
COPY scripts /app/scripts

# Make the scripts executable
RUN chmod -R +x /app/scripts

# Create the logs directory
RUN mkdir -p /app/logs

# Copy the supervisord configuration file
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make the entrypoint script executable
RUN chmod +x /app/scripts/docker-entrypoint.sh

# Use supervisord as the entrypoint
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]

# Run the supervisor in the foreground
CMD ["-n"]
