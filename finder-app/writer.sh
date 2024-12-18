#!/bin/bash

if [ "$#" -lt 2 ]; then
	echo "Invalid args"
	exit 1
fi

# full path to a file (including filename)
writefile=$1
# a text string which will be written within this file
writestr=$2

dir=$(dirname "$writefile")
if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
fi

echo "$writestr" > "$writefile"

if [ 0 -ne $? ]; then
	echo "File could not be created"
	exit 1
fi
