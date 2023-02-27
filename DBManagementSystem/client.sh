#!/bin/bash

function ctrl_c() {
	rm "${1}.pipe"
	echo "shutdown" > server.pipe
	exit 0
}

if [ -z "$1" ]; then
	echo "Error: no parameter"
    exit 1
fi

mkfifo "${1}.pipe"
trap "ctrl_c $1" INT
recieved=""

while true; do
	read -r input
	case "$input" in
		shutdown|quit)
			rm "${1}.pipe"
			echo "$1 shutdown" > server.pipe
			exit 0
		;;
		*)
			echo "$1 $input" > server.pipe
	esac
	output=$(cat "${1}.pipe")
	if [ "$recieved" != "$output" ]; then
		while IFS= read -r l; do
			if [[ $l == Error* ]]; then
				echo "command failed to execute"
				echo "$l"
			elif [[ $l == OK* ]]; then
				echo "command successfully executed"
			elif [[ $l != start_result ]] && [[ $l != end_result ]]; then
				echo "$l"
			fi
		done <<< "$output"
		recieved="$output"
	fi
done
