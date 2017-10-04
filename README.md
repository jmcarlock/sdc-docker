# rpi-jessie-opencv3.2



Dockerfile to create a container for Raspberry Pi with Raspbian jessie and opencv3.2

Extension of the resin.io Raspberry Pi base image (jessie) with OpenCV 3.2 libraries and python 2.7 bindings added. Installation based upon instructions from:
http://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/

## To build:

    docker build -ti rpi-jessie-opencv3.2 

## To use:

How to Use
As a source container
Use as a source container for a docker build to avoid a long build of Open CV.

To use for development of OpenCV applications you will probably need other libraries and may simply want to use this as a source container to avoid the long OpenCV build.

Open CV App Development
To develop apps within the container you may want to display images and/or mount a host directory to act as a persistent file store for source and images.

To display windows created by Open CV properly start docker with the following command:

	docker run -ti -e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		rickryan/rpi-jessie-opencv3.2:latest
To mount a host directory for development (e.g., where source files for your Open CV application are stored) use the -v option for the run command:

	docker run -ti -e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-v hostDirectoryPath:containerDirectory \
		rickryan/rpi-jessie-opencv3.2:latest
obviously replacing hostDirectoryPath and containerDirectory

One trick is to move to the directory containing your source code and start the docker container with:

	docker run -ti -e DISPLAY=$DISPLAY \
    		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    		-v `pwd`:`pwd` -w `pwd` \
    		rickryan/rpi-jessie-opencv3.2:latest
this will mount your current directory on the host in the same path with the docker container and start you in that directory.
