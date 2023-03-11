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
