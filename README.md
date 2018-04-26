##News Report tool

###Purpose
This script reads the content of access logs in the news database and displays three reports:  
1. Most popular three articles of all time  
2. Most popular article authors of all time  
3. Days with error requests higher than 1% 

**Note:** This script was written in Python 3. Running with Python 2 is not recommended. 

###Package contents
* **README.md** (This file)
* **RESULTS.md**  
The results obtained after executing the script. 
* **sqlCode.sql**  
All the database code used to generate the reports.
* **reportdb.py**  
Python script used to query the database and display the results.


###Directions

####Simple instructions
If you are experienced with databases and python, all you have to do is:  
1. Import the **"news"** database;  
2. Execute **sqlCode.sql** to create in the database all the queries;  
3. Run **reportdb.py** with Python 3.

In other cases, just follow the detailed instructions below.

####1 - Setting up the database
In order to use this report tool you must first import the news data (newsdata.sql) into your database.

Assuming you already have PostgreSQL up and running (if not, try this article), you can import the data using this command:  
```$ psql -d news -f newsdata.sql```  
If this command gives an error message, such as —
```psql: FATAL: database "news" does not exist```   
```psql: could not connect to server: Connection refused```
— this means the database server is not running or is not set up correctly.

If you are sure that the server is running, create the db with 
```$ createdb news```   
Then run the import command again.

After that, execute/import the file **sqlCode.sql** with ```$ psql -d news -a -f sqlCode.sql ```   or 
1. Open the file in a simple text editor;  
2. Copy all the content, paste in the postgres shell and execute;  

####2 - Running the script
In the terminal/MS-DOS Prompt/Shell just run the following command 
```$ python reportdb.py```