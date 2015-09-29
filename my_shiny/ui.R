library(shiny)

library(RMySQL)

mydb = dbConnect(MySQL(), user='cl41-chirag-rsu', password='123456', dbname='cl41-chirag-rsu', host='79.170.44.91', port=3306);

state = dbSendQuery(mydb, "select * from state")
stateData = fetch(state, n = -1)
bm = dbSendQuery(mydb, "select * from fnbusiness_main")
bmData = fetch(bm, n = -1)
bc = dbSendQuery(mydb, "select * from fnbusiness_category")
bcData = fetch(bc, n = -1)

shinyUI(fluidPage(
  titlePanel("Our Analysis"),
  
  
  sidebarLayout(
      sidebarPanel(
        selectInput("choice1", "Select a state:", 
                    choices = stateData$NAME),
        selectInput("choice2", "Select a city:", 
                    choices = " "),
        selectInput("choice3", "Select a business_category:", 
                    choices = sort(unique(bcData$category)))
      ),
    mainPanel(
      textOutput("text1"),
      textOutput("text2")
    )
  )
))