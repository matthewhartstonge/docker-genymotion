#!/usr/bin/env bash
# This enables root to run X server - the linux window system
xhost local:root

# run the container to fail
docker run -d \
    --privileged \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`/persistent_data/genymotion:/root/ \
    --name dkms \
    matthewhartstonge/genymotion

# Copy the vbox driver and libs from the named dkms container
docker cp dkms:/usr/lib/virtualbox/vboxdrv.sh .
docker cp dkms:/usr/share/virtualbox /usr/share

# Install the DKMS modules on the host
./vboxdrv.sh setup

# Remove libs and build script
rm vboxdrv.sh
rm -rf /usr/share/virtualbox

# Kill off and cleanup unneeded container
docker kill dkms
docker rm dkms
