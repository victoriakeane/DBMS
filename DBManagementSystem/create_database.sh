#!/bin/bash 

./P.sh "$1"
if [ -z "$1" ]; then
	echo "Error: no parameter"
	./V.sh "$1"
    exit 1
elif [ -d "$1" ]; then
	echo "Error: DB already exists"
	./V.sh "$1"
    exit 1
else
	mkdir "$1"
	echo "OK: database created"
	./V.sh "$1"
    exit 0
fi
