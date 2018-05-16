# EOgmaNeo Raspberry Pi3 Self-Driving Car #
## Docker image containing dependencies of EOgmaDrive for Raspberry Pi3 Stretch ##
 

This is a docker image of required dependencies compiled for the Raspberry Pi specifically for the [EOgmaDrive Configuration1 self-driving car](https://github.com/ogmacorp/EOgmaDrive/tree/master/Configuration1). 

Forked [rpi-raspbian-docker](https://github.com/sgtwilko/rpi-raspbian-opencv) for OpenCV. Also includes EOgmaNeo, Numpy, PyGame, Pillow, Jupyter, and Serial. It includes python bindings for both Python2 and Python3, but EOgmaNeo is installed for Python3 only.

This uses resin.io Raspberry Pi base images and compiles OpenCV 3.4.1+ and EOgmaNeo for python3.  
Installation is based upon instructions at http://www.pyimagesearch.com.


## Installation and Usage ##

Pull the Docker image:

	docker pull ylustina/sdc-docker:firsttry

To run the Docker container:

	docker run -ti --device=/dev/vcsm \
    		--device=/dev/vchiq \
    		-e DISPLAY=$DISPLAY \
    		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    		-v /home/pi/test/:/home/ \
    		-p 8888:8888 \
    		ylustina/sdc-docker:firsttry /bin/bash


https://hub.docker.com/r/ylustina/sdc-docker/


+
+


## The Building Process ##

Needed a minimum of a 16GB SDCard, 32GB recommended and more than 7GB of free space.

Assuming you already have docker working on your system you will then need to increase the swap size on the RPi.  
To do this you will need to edit `/etc/dphys-swapfile`.

Comment out the line:
`#CONF_SWAPSIZE=100`
and uncomment and edit the remaining lines as follows:

	# set size to computed value, this times RAM size, dynamically adapts,
	#   guarantees that there is enough swap without wasting disk space on excess
	CONF_SWAPFACTOR=1
	
	# restrict size (computed and absolute!) to maximally this limit
	#   can be set to empty for no limit, but beware of filled partitions!
	#   this is/was a (outdated?) 32bit kernel limit (in MBytes), do not overrun it
	#   but is also sensible on 64bit to prevent filling /var or even / partition
	CONF_MAXSWAP=4096

Then remember to restart the swap service:

	$ sudo /etc/init.d/dphys-swapfile stop
	$ sudo /etc/init.d/dphys-swapfile start

Without this, the RPi will run out of RAM and will crash at around 86% during the build.

During building your RPi will run at 100% CPU for an extended amount of time.  It will run hot, I've seen mine hit 85°C.

I wouldn't recommend trying to build without a Heatsink, a fan is not necessary, but will speed up the process as the CPU will slow down as it reaches/exceeds 80°C.

A basic build will take between 2 and 4 hours on a RPi 3B, and can be kicked off by:

	$ git clone https://github.com/ylustina/sdc-docker.git
	$ cd sdc-docker
	$ docker build -t sdc-docker ./stretch

The `-t` parameter is providing the tag you'll use to identify this image.
