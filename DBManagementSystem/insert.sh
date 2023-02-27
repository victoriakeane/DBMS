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
elif [ ! -f "$1/$2" ]; then
	echo "Error: table does not exist"
	./V.sh "$1"
    exit 1
else
	num_vars=$(echo $3 | tr ',' '\n' | wc -l)
	cols=$(head -n 1 "$1/$2")
	num_cols=$(echo $cols | tr ',' '\n' | wc -l)
	if [ $num_vars -ne $num_cols ]; then
		echo "Error: number of columns in tuple does not match the schema"
		./V.sh "$1"
    	exit 1
	else
		echo $3 >> "$1/$2"
		echo "OK: tuple inserted"
		./V.sh "$1"
    	exit 0
	fi
fi
