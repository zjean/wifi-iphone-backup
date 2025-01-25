#!/bin/bash

# Get the binaries
echo "Getting binaries..."
/app/scripts/get-binaries.sh

# Make the scripts executable
echo "Making scripts executable..."
chmod -R +x /app/bin/

# Start avahi-daemon in the background
echo "Starting avahi-daemon service..."
rm -rf /run/avahi-daemon//pid && avahi-daemon -D 

# Purge logs
echo "Purging logs..."
rm -rf /app/logs/*


# Execute supervisord
echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
