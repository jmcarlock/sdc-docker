#!/bin/bash


git ls-remote --tags https://github.com/opencv/opencv | grep -v '{}\|-' | awk -F"/" '{print $3}' | sort -n -t. -k1,1 -k2,2 -k3,3 -k4,4 | awk -F"." '{if (($1>3) || ($1==3 && $2>3) || ($1==3 && $2==3 && $3>=1)) print $0;}'
