# DBMS
A rudimentary database management system (DBMS). The DBMS is based on an SQL style database, with the possibility of multiple databases to be defined on the server, an each database storing its data in tables with a static number of columns defined upon the tables creation. These tables are not horizontally scalable, though should easily scale vertically with the possibility of adding data to any table in the form of rows.

Each database will be stored as a folder on the server, with each table being stored as a file. As a result of this, database/table names can be easily found using the Unix `ls` function, other other operations can be performed on the databases and tables directly using sh or Bash scripting, though as you will see the DBMS should cover any basic functionality needed and should be used in place of these operations. Below is an outline of what will be possible in the DBMS.


A server.sh script is used to start up the server which handles the DBMS operations, simply run the server.sh script which will take in a stream of commands until `shutdown` is entered, at which point the script will be terminated. The commands which are accepted include;


`create_database <database name>`
`create_table <database name> <table name>`
`insert <database name> <table name> <tuple containing row data>`
`select <database name> <table name> <first column index>,<second column index>`
`delete <database name>`
`delete <database name> <table name>`
`delete <database name> <table name> <row index>`


Client.sh can be run in a similar manner to server.sh, client.sh takes in a stream of commands and sends them onto server.sh through the server.pipe pipe. When client.sh is first run it looks for an ID, `client.sh <id>` this is then used to name the pipe which the server will use to communicate with said client (<id>.pipe). 

Each command that is entered into the client script will be sent to the server.pipe pipe along with the client's ID. The server can then pass the output of these commands back to <id>.pipe for the client to pick up and output to the console. Multiple clients can communicate with the server at a once. 

Each of the sh scripts which define the commands include a lock system, locking the database folder which contains the data being used while the operations take place, this prevents two clients from attempting to alter a file simultaneously causing issues for both clients. The scripts P.sh and V.sh are used to execute the lock.


## Overview of command files


### create_database.sh
This script is run using the following syntax `./create_database.sh <database name>`. If the database name is not included as a positional arguements an error is thrown. The script also checks the current directory for a folder of the name specified and if one is present another error is thrown alerting the user that the database specified is already present. If neither of these errors are triggered a folder is created in the server directory with the name <database name> (mkdir <database name>).

### create_table.sh
This script is run with the following command `./create_table.sh <database name> <table name> <column name tuple>`. It first checks if the correct number of positional parameters are provided and if not throws an error. It then checks if the database provided exists, if not an error is thrown, if so the database folder is checked for a file matching the table name provided and if no such file exists by that name one is created. Otherwise an error is thrown. The columns tuple provided is simply saved to the newly created file as is.

###insert.sh
This script is run as follows, `./insert.sh <database name> <table name> <data row tuple>` This script runs almost identically to create_table.sh, though instead of creating a new file with the column name tuple as its only entry, it looks for a table in the database folder of the names provided and if one exists it appends the tuple, if not it throws an error.

### select.sh
Select.sh is the first script to become a little less straight forward. It runs through the usual checks, is the database present, is the table present, is there the correct number of postional arguments, etc. then if there are no column indexes provided it simply outputs the result of `cat <database name>/<table name>` with “start result” and “end resut” prepended and appended onto the multi line string to the console. Where it got a little trickier was finding the rows by index. How I did this was to read the file line by line, for each line I would split the line into an array using ',' as the IFS. I also stored the column indiceses in an array using the ssame method. I then looped though each of the column indices in a for loop with `i` representing the current index, I then queryed the row data array for that index and appended it to the output string. After each run of the inneer for loop a newline character was appended to the output string. The usual start result and end result strings were also appended and prepended to the output string, with the string being sent to the client pipe once completed.

### delete.sh
The delete.sh script's functionality differs depending on the number of postional variables defined when the command is run. Checks are in place ensuring the database/ table are present as well as checking that the correct number of positional arguments are being used, 1, 2 or 3 positional arguments are all acceptable. If any of these checks do not pass, then an error is thrown.
If one positional argument is passed then the purpose of the script is to remove a database. The database name is passed in and the folder matching the name is removed along with all of its comments using the recursive `rm -r <folder name>` command.
If two positional arguements are passed in a table is to be deleted. The file containing the table information is simply removed using `rm <database name>/<table name>`.
Finally if 3 positional arguements are supplied, a row from the table will be removed. This involves the use of the file stream editor `sed` to remove a line in the file at the given index, taking care to ignore the first line of the file which is reservered for the column names.


### server.sh
Server.sh is fairly simple, it uses a while loop which constantly loops, asking the client for commands, these commands are outlined in the previous section. The client sends the command followed by the client id. The server.sh script then runs the appropriate sh file in the background, sending the output to <id>.pipe. Once the command `shutdown` is entered it removes the server.pipe pipe and exits the program.

### client.sh
Client.sh is reasonably straight forward also. It is started using the following command `./client.sh <id>` a pipeline is then created under the name <id>.pipe. It then loops continuosly like the server.sh script querying the user for a command, when a command is inputted, the client id is appended to the end of the string and the resulting string is sent to the server.pipe pipeline. The output is then taken from <id>.pipe and parsed appropriately.

### P.sh & V.sh
P.sh is used in this project to lock a database folder when operations are taking place inside it to avoid clients simultaneosly accesing data and causing potential issues. V.sh is then used to unlock the folder. The Unix function `ln` is used between the P.sh file and a <database name>-lock file as the immutable instruction needed in a semaphore lock.
