FROM ubuntu:16.04
MAINTAINER Matthew Hartstonge <matt@mykro.co.nz>

# Specify the binary we want to use
ENV GENY_VERSION=2.7.2

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        linux-headers-4.4.0-22-generic \
        openssl \
        wget \
    \
    # Install Virtual Box 5.0
    && wget -q --directory-prefix=/tmp/ "http://files2.genymotion.com/genymotion/genymotion-${GENY_VERSION}/genymotion-${GENY_VERSION}-linux_x64.bin" \
    && echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list \
    && wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add - \
    && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add - \
    && apt-get update && apt-get install -y \
        virtualbox-5.0 \
    \
    # Install Genymotion
    && mkdir -p /genymotion/ \
    && apt-get install -y --no-install-recommends \
        bzip2 \
        libgstreamer-plugins-base0.10-dev \
        libxcomposite-dev \
        libxslt1.1 \
    && chmod +x /tmp/genymotion-${GENY_VERSION}-linux_x64.bin \
    && mkdir -p /root/.Genymobile/ \
    # Weird AUFs bug errors with 'file in use', fixed with sync command
    && sync \
    && echo 'Y' | /tmp/genymotion-${GENY_VERSION}-linux_x64.bin -d / \
    \
    # Cleanup
    && rm -f /tmp/genymotion-${GENY_VERSION}-linux_x64.bin \
    && apt-get autoremove -y --purge \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/tmp/.X11-unix", "/root/"]
ENTRYPOINT ["/genymotion/genymotion"]
