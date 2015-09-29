# Project group 3
# Authors : Chirag, Latish, Shiv
# College : RIT

# devtools::install_github("rstudio/leaflet")

library(shiny)
library(RMySQL)
library(leaflet)
library(plyr)
library(dplyr)
library(stringr)

# make sure path is correct
# pos = readLines("positive-words.txt")
# neg = readLines("negative-words.txt")

bc <- c("Any","Nightlife","Bars","Grocery","Hotels","Dance Clubs")

#modified by: group 3 Big Data project.
myfunction <- function(sentence, pos.words, neg.words)
{
  # remove punctuation
  sentence = gsub('[[:punct:]]', '', sentence)
  # remove control characters
  sentence = gsub('[[:cntrl:]]', '', sentence)
  # remove digits?
  sentence = gsub('\\d+', '', sentence)
  
  sentence = tolower(sentence)
  
  # split sentence into words with str_split (stringr package)
  word.list = str_split(sentence, '\\s+')
  words = unlist(word.list)
  
  # compare words to the dictionaries of positive & negative terms
  pos.matches = match(words, pos.words)
  neg.matches = match(words, neg.words)
  
  # get the position of the matched term or NA
  # we just want a TRUE/FALSE
  pos.matches = !is.na(pos.matches)
  neg.matches = !is.na(neg.matches)
  
  # final score
  score = sum(pos.matches) - sum(neg.matches)
  return(score)
}

myResults <- read.csv("arizonaSentiment-1.csv")
mydb = dbConnect(MySQL(), user='cl41-chirag-rsu', password='123456', dbname='cl41-chirag-rsu', host='79.170.44.91', port=3306);
state = dbSendQuery(mydb, "select * from state")
stateData = fetch(state, n = -1)
bm = dbSendQuery(mydb, "select * from fnbusiness_main")
bmData = fetch(bm, n = -1)
# bc = dbSendQuery(mydb, "select * from fnbusiness_category")
# bcData = fetch(bc, n = -1)
# review = dbSendQuery(mydb, "select * from reviewData")
# reviewData = fetch(review, n = -1)
# reviewData["reviewScore"] <- 0

# for(i in 1:length(reviewData$text)) {
  # reviewData$reviewScore[i] <- myfunction(reviewData$text[i],pos,neg)
# }


# myResults <- ddply(reviewData, 
#                    .(business_id,name,longitude,latitude,city, review_count),
#                   summarize, 
#                   averageSentimentScore = mean(reviewScore), averageRating=mean(stars)
# )

# View(myResults)

#pal is creation of the palette here with Red-Yellow-Blue colors and 8 variations of those colors.
pal<-colorQuantile("RdYlBu",NULL,n=8)
# '%>%' is composition of functions!, content is creating the info to be displayed for popup. 
content <- paste(sep = "<br/>",myResults$name,
                 paste("Rating:",format(round(myResults$averageRating,2), nsmall=2)),
                 paste("Sentiment:",format(round(myResults$averageSentimentScore,2), nsmall=2)),
                 paste("Total Reviews:",format(round(myResults$review_count,2), nsmall=2)))




ui <- shinyUI(fluidPage(
  
  titlePanel("Yelp Dataset Analysis - By Chirag, Latish & Shiv"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("choice1", "Select a state:", 
                  choices = stateData$NAME),
      selectInput("choice2", "Select a city:", 
                  choices = " "),
      selectInput("choice3", "Select a business_category:", 
                  choices = sort(bc))
    ),
    mainPanel(
      textOutput("text1"),
      textOutput("text2")
    )
  ),
  textOutput("text3"),
  leafletOutput("mymap")
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, clientData, session) {
  
  observe({
    stateAbbr <- stateData$ID[stateData$NAME == input$choice1]
    
    output$text1 <- renderText({ 
      paste("You have selected", input$choice1 , 
            " , which has the abbrevation of ", stateAbbr , 
            ". You have selected city ", input$choice2 ,
            " . The business choice you choose is ", input$choice3)
    })
    
    city_options <- sort(unique(bmData$city[bmData$state == stateAbbr]))
    
    updateSelectInput(session, "choice2",
                      choices = city_options
    )
  })
  
  output$text3 <- renderText({
    paste("Note: More reviews lead to bigger circle radius. Click on a marker point in the map to know more about it.")
  })
  
  output$mymap <- renderLeaflet({
    # updateReviewData(input$choice2)
    myResultsTemp <- myResults[myResults$city == input$choice2,]
    
    if(input$choice3 != "Any") {
      myResultsTemp <- myResultsTemp[myResultsTemp$category == input$choice3,]
    }
    
    
    
    # updateMapParams()
    # View(myResultsTemp)
    
    # if(nrow(myResultsTemp) < 15) return(NULL)
    
    # myResults <- ddply(reviewDataTemp, 
    #                   .(business_id,name,longitude,latitude,city, review_count),
    #                   summarize, 
    #                   averageSentimentScore = mean(reviewScore), averageRating=mean(stars)
    # )
    
    # View(myResults)
    #pal is creation of the palette here with Red-Yellow-Blue colors and 8 variations of those colors.
    pal<-colorQuantile("RdYlBu",NULL,n=8)
    # '%>%' is composition of functions!, content is creating the info to be displayed for popup. 
    content <- paste(sep = "<br/>",myResultsTemp$name,
                     paste("Rating:",format(round(myResultsTemp$averageRating,2), nsmall=2)),
                     paste("Sentiment:",format(round(myResultsTemp$averageSentimentScore,2), nsmall=2)),
                     paste("Total Reviews:",format(round(myResultsTemp$review_count,2), nsmall=2)))
    
    # plot leaflet
    leaflet(myResultsTemp)%>%addTiles()%>%
      addCircleMarkers(color=~pal(myResultsTemp$averageRating),
                       popup=~content, radius = ~sqrt(myResultsTemp$review_count)*0.6, 
                       weight = 2,fillOpacity = 0.6, 
                       opacity = 0.8)%>% 
      addProviderTiles("CartoDB.Positron") %>%
      addLegend("bottomright", 
                 pal = pal, 
                 values = ~myResultsTemp$review_count,
                 title = "Average Review Star Ratings",
                 layerId = 2,
                 opacity = 1)
  })
})

dbDisconnect(mydb);
shinyApp(ui = ui, server = server)

