#!/bin/bash

mkfifo server.pipe
recieved=""
id=""

while true; do
	read input < server.pipe
	if [ "$recieved" != "$input" ]; then
		recieved="$input"
		set -- $input
		id="$1"
		case "$2" in
			create_database)
				echo "$(./create_database.sh "${@:3}" &)" > ${id}.pipe
			;;
			create_table)
				echo "$(./create_table.sh "${@:3}" &)" > ${id}.pipe
			;;
			insert)
				echo "$(./insert.sh "${@:3}" &)" > ${id}.pipe
			;;
			select)
				echo "$(./select.sh "${@:3}" &)" > ${id}.pipe
			;;
			delete)
				echo "$(./delete.sh "${@:3}" &)" > ${id}.pipe
			;;
			shutdown)
				rm server.pipe
				exit 0
			;;
			*)
				echo "Error: bad request" > ${id}.pipe
				rm server.pipe
				exit 1
		esac
	fi
done
