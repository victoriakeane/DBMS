#!/bin/bash

# script to delete a database, a table or a row (by index)

./P.sh "$1"
if [ "$#" -gt 3 ] || [ "$#" -lt 1 ]; then
	echo "Error: parameters problem"
	./V.sh "$1"
    exit 1
elif [ ! -d "$1" ]; then
	echo "Error: DB does not exist"
	./V.sh "$1"
    exit 1
else
	# delete db
	if [ "$#" -eq 1 ]; then
		echo "OK: database deleted"
		rm -r "$1"
	# delete table
	elif [ "$#" -eq 2 ]; then
		if [ ! -f "$1/$2" ]; then
			echo "Error: table does not exist"
			./V.sh "$1"
		    exit 1
		fi
		echo "OK: table deleted"
		rm "$1/$2"
	# delete row by index
	elif [ "$#" -eq 3 ]; then
		if [ ! -f "$1/$2" ]; then
			echo "Error: table does not exist"
			./V.sh "$1"
		    exit 1
		fi
		num_rows=$(wc -l < "$1/$2")
		selected_row=$(($3+1)) # ignore the column names
		if [ "$selected_row" -gt "$num_rows" ] || [ "$selected_row" -le 1 ]; then
			echo "Error: row index out of bounds"
			./V.sh "$1"
			exit 1
		fi
		sed -i '' "${selected_row}d" "$1/$2"
		echo "OK: row deleted"
	fi
	./V.sh "$1"
	exit 0
fi
