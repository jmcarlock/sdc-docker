#! /bin/bash

#Grab the ID of the latest image.
function fn_getID(){
	local tag=$1
	docker pull resin/rpi-raspbian:$tag
	fn_getID=$( docker images resin/rpi-raspbian:$tag --format "{{.ID}}" )
	#echo $fn_getID
}

#Add a tag to the new image, remove it from the old one first.
function fn_addTag(){
	echo "Tagging $myTag as sgtwilko/rpi-raspbian-opencv:$1"
	docker rmi sgtwilko/rpi-raspbian-opencv:$1
	docker tag $myTag sgtwilko/rpi-raspbian-opencv:$1
	docker push sgtwilko/rpi-raspbian-opencv:$1
}

#Get the ID of the resin/rpi-raspbain image tagged as latest.
fn_getID "latest"
latestID=$fn_getID

#If we need to force a full rebuild for some reason, even if the base images haven't changed.
rebuild=$1

#Array of supported OpenCV versions, latest version at the END!
opencv_vers=(`./getOpenCVTags.sh`)

#Grab latest version (should be last in array)
opencv_latest=${opencv_vers[-1]}
#build date.
today=$(date -u +'%Y%m%d')
imageBuilt=0

for D in *; do
    if [ -d "${D}" ]; then
        echo "Checking ${D}..."
	echo ""
	fn_getID ${D}
	myID=$fn_getID
	lastID=$( cat ./${D}/rpi-raspbian.id )
	if [[ ("$myID" != "$lastID") || ("$rebuild" == "1") ]]
	then
		for opencv_ver in "${opencv_vers[@]}"; do
			echo "Rebuilding for OpenCV $opencv_ver."
			myTag=sgtwilko/rpi-raspbian-opencv:${D}.$today-$opencv_ver
			#echo "$myTag"
			time docker build --build-arg OPENCV_VERSION=$opencv_ver --build-arg RASPBIAN_VERSION=${D} --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` -t $myTag ./${D}
			rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
			#Image built ok...
			((imageBuilt++))
			docker push $myTag
			fn_addTag ${D}-$opencv_ver
			if [[ ("$opencv_ver" == "$opencv_latest") ]]
			then
				fn_addTag ${D}-latest
				if [[ ("$myID" == "$latestID") ]]
				then
					fn_addTag latest-latest
					fn_addTag latest
				fi
			fi
			if [[ ("$myID" == "$latestID") ]]
			then
				fn_addTag latest-$opencv_ver
			fi
			#docker push
			echo "$myID" > ./${D}/rpi-raspbian.id
		done
	fi
    fi
done

#if (( $imageBuilt > 0 ))
#then
#	docker push sgtwilko/rpi-raspbian-opencv
#fi
