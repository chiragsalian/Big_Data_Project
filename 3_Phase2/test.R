source("/Users/chiragsalian/Study/2.5 - Summer/Big Data/Project/3_Phase2/sentiment function code.R");

library(shiny)
# library(RMySQL)
mydb = dbConnect(MySQL(), user='root', password='1234', dbname='yelp', host='localhost');
# mydb = dbConnect(MySQL(), user='cl41-db-w5s', password='Apple250492', dbname='cl41-db-w5s', host='79.170.44.91', port=3306);

state = dbSendQuery(mydb, "select * from state")
stateData = fetch(state, n = -1)
bm = dbSendQuery(mydb, "select * from fnbusiness_main")
bmData = fetch(bm, n = -1)
bc = dbSendQuery(mydb, "select * from fnbusiness_category")
bcData = fetch(bc, n = -1)

# myfunction("I had a bad experience in the hotel",pos, neg)

runApp("/Users/chiragsalian/Study/2.5 - Summer/Big Data/Project/my_shiny")