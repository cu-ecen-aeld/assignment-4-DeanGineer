#!/bin/sh

filesdir="$1"
searchstr="$2"

if [ "$#" -lt 2 ]; then
	echo "Invalid args"
	exit 1
fi

if [ -d "$filesdir" ]; then
	:
else
	echo "Invalid directory for the first argument"
	exit 1
fi

num_files=$(find "$filesdir" -type f | wc -l)
num_matching_lines=$(grep -r "$searchstr" "$filesdir" 2>/dev/null | wc -l)
echo "The number of files are $num_files and the number of matching lines are $num_matching_lines."




