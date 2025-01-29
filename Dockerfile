FROM debian:bookworm AS build

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    ca-certificates \
    build-essential \
    pkg-config \
    checkinstall \
    usbutils \
    git \
    make automake autoconf libtool pkg-config gcc \
    libcurl4-openssl-dev \
    libssl-dev \
    avahi-daemon \
    avahi-utils \
    libnss-mdns \
    avahi-discover

ENV INSTALL_PATH=/app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH
RUN git clone https://github.com/libimobiledevice/libplist.git \
&& cd $INSTALL_PATH/libplist \
&& ./autogen.sh \
&& make \
&& make install

WORKDIR $INSTALL_PATH
RUN git clone https://github.com/libimobiledevice/libimobiledevice-glue \
&& cd $INSTALL_PATH/libimobiledevice-glue \
&& ./autogen.sh \
&& make \
&& make install


WORKDIR $INSTALL_PATH
RUN git clone https://github.com/libimobiledevice/libtatsu \
&& cd $INSTALL_PATH/libtatsu \
&& ./autogen.sh \
&& make \
&& make install


WORKDIR $INSTALL_PATH
RUN git clone https://github.com/libimobiledevice/libusbmuxd.git \
&& cd $INSTALL_PATH/libusbmuxd \
&& ./autogen.sh \
&& make \
&& make install

WORKDIR $INSTALL_PATH
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git \
&& cd $INSTALL_PATH/libimobiledevice \
&& ./autogen.sh \
&& make \
&& make install


FROM debian:bookworm
COPY --from=build /usr/local/ /usr/local/


# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libavahi-compat-libdnssd-dev \
    libusb-1.0-0-dev \
    # libclang-dev \
    # libusbmuxd-dev \
    # libimobiledevice-utils \
    # ideviceinstaller \
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
