README.TXT
3rd August 2015

//=================== Loading the SQL DB Locally ========================================
First load the java parser and driver in your work environment. The necessary 
JSON and mysql jar libraries are provided as well in the lib folder.

Change the username, host and password to match your current MYSQL's credentials in the 
parser.java.

Run the table SQL commands as mentioned in the file Table_Code.txt to get the proper 
relational db structure.

Load the sample JSON files as provided in the Subset JSON files folder. Once these files
are loaded in the environment run the driver.java file. It should parse through the data
to load them in your respective mysql.

Once loaded you should notice a structure in your respective DB manager. The screenshot 
of ours is provided in the screenshot folder.

After that you can run the provided R codes to see the same outputs as the one mentioned
in our document. A sample csv has been provided as well that has a joined table that we 
used for our most latest analysis.
==========================================================================================



//=============== Running app.R (No Need of db loading) ==================================
Load the app.r file in your respective R or RStudio.

You may need to install the respective libraries depending on the ones used within app.R. The code in this script connects to a remote db so loading the previous db would not be required since it is handled remotely by us in ecowebhosting.com.

The code takes a short while to run and its dependent on the csv and positive and negative text files within the same document. As long as the paths aren’t modified in the folder it will run just fine.
=========================================================================================



//=============== Running Already Published Code =========================================
Visit - https://latishk.shinyapps.io/my_shiny_v2-6

This domain already runs our app.R code to convert our entire R project into a dynamic HTML page using shiny api’s. Since we have loaded the domain with a remote sql connection it took a while to publish and obtain the sql the first time. Now, it should run smoothly with less load times. All the descriptive sentiment analysis of cities within Arizona should load up quite fast. Even though we use an almost 1 million dataset, if a city doesn’t have the necessary data a blank map or an error is thrown. 

Future increments on the project would work towards resolving these issues.
=========================================================================================
