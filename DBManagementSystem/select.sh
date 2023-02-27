#!/bin/bash

./P.sh "$1"
if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then
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
	if [ -z "$3" ]; then
		echo "start_result"
		cat "$1/$2"
		echo "end_result"
		./V.sh "$1"
		exit 0
	else
		cols=$(head -n 1 "$1/$2")
		num_cols=$(echo $cols | tr ',' '\n' | wc -l)
		IFS=","
		for i in $3; do
			if [ "$i" -gt "$num_cols" ] || [ "$i" -le 0 ]; then
				echo "Error: column does not exist"
	    		exit 1
			fi
		done
		output="start_result\n"
		IFS=""
		while read l; do
			IFS="," read -ra tuple <<< "$l"
			IFS="," read -ra indices <<< "$3"
			for i in "${indices[@]}"; do
				output+="${tuple[i-1]}, "
			done
			# replace trailing ',' with a '\n'
			output=${output::${#output}-2}
			output+="\n"
		done < "$1/$2"
		output+="end_result"
		echo -e "$output"
		./V.sh "$1"
		exit 0
	fi
fi
