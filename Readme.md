# docker-genymotion

Base Image: ubuntu:16.04

docker-genymotion helps to keep your environment clean and consistent when 
testing different devices. It seeks to ensure the application is portable 
across multiple platforms, hence a docker container.

## Quickstart docker-genymotion
I have included a docker-compose file to enable fast-tracked development and 
play with the image.

### Build or pull docker-genymotion
You can pull the image straight from docker hub with:

```sh
docker pull matthewhartstonge/genymotion
```

OR, download the [Git repository][gitrepo] and and as long as you have 
[docker-compose][dockercompose] installed, run:

```sh
docker-compose build
```

### Run docker-genymotion
#### First run
To initially run the container you will need to pull out the virtualbox files 
from the container to build and install the DKMS modules required for 
genymotion to run correctly on your host. Run setup.sh from the root of the 
repository or copy and paste the following into your shell:

```sh
# This enables root to run X server - the linux window system
xhost local:root

# Generate folder for persistent data
mkdir -p `pwd`/persistent_data/genymotion/.Genymobile
chown -R root:root `pwd`/persistent_data/*

# Run the container to extract files from
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

# Ensure you have the kernel sources available and built, for example:
#  zypper in kernel-source kernel-default-devel
#  ln -s /usr/src/linux-* /usr/src/linux
#  cd /usr/src/linux
#  make oldconfig prepare scripts

# Install the DKMS modules on the host
./vboxdrv.sh setup

# Remove libs and build script
rm vboxdrv.sh
rm -rf /usr/share/virtualbox

# Kill off and cleanup unneeded container
docker kill dkms
docker rm dkms
```

#### With vanilla docker
Once the image and the DKMS modules have been built and installed as
 above, run the following as root:
```sh
docker run -d \
    --privileged \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`/persistent_data/genymotion:/root/ \
    matthewhartstonge/genymotion
```

#### With docker-compose
Once the image and the DKMS modules have been built and installed as
 above, run the following as root:
```sh
# Run the container with the settings defined in docker-compose.yml
docker-compose up
```

## FAQ
#### Hey, it complains about virtualbox not existing?
It requires the container's virtualbox Dynamic Kernel Module Support (DKMS) to
 be built and installed on the host due to needing the pass-through 
 visualisation.

#### Y U NO WINDOWS??
I have tried virtualbox within virtualbox, but this fails... The passthrough of
the DKMS/virtualbox tools gets messy. As such this container is best run on an
 operating system that supports native docker. i.e. linux. NOT in a virtualbox
 VM. 
 
If anybody wants to report back on experience with running this in a linux
 VM on windows through Parallels, VMWare e.t.c. let me know of your findings.

#### Can I report a bug?
Absolutely! File via [github issues][gitissues], or better yet, send a PR ;)


[dockercompose]: <https://docs.docker.com/compose/install/>
[gitrepo]: <https://github.com/MatthewHartstonge/docker-genymotion>
[gitissues]: <https://github.com/MatthewHartstonge/docker-genymotion/issues>
