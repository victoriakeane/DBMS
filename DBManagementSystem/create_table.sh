#!/bin/bash 

./P.sh "$1"
if [ "$#" -ne 3 ]; then
	echo "Error: parameters problem"
	./V.sh "$1"
    exit 1
elif [ ! -d "$1" ]; then
	echo "Error: DB does not exist"
	./V.sh "$1"
    exit 1
elif [ -f "$1/$2" ]; then
	echo "Error: table already exists"
	./V.sh "$1"
    exit 1
else
	echo $3 > "$1/$2"
	echo "OK: table created"
	./V.sh "$1"
    exit 0
fi
