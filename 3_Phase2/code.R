# Project group 3
# Authors : Chirag, Latish, Shiv
# College : RIT

# install.packages("plyr")
# install.packages("dplyr")
# install.packages("leaflet")

library(leaflet)
library(plyr)
library(dplyr)
library(RMySQL)
library(stringr)

# make sure path is correct
pos = readLines("positive-words.txt");
neg = readLines("negative-words.txt");

#modified by: group 3 Big Data project.
myfunction<-function(sentence, pos.words, neg.words)
{
  # remove punctuation
  sentence = gsub("[[:punct:]]", "", sentence)
  # remove control characters
  sentence = gsub("[[:cntrl:]]", "", sentence)
  # remove digits?
  sentence = gsub('\\d+', '', sentence)
  
  # define error handling function when trying tolower
  tryTolower = function(x)
  {
    # create missing value
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error=function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
      y = tolower(x)
    # result
    return(y)
  }
  # use tryTolower with sapply 
  sentence = sapply(sentence, tryTolower)
  
  # split sentence into words with str_split (stringr package)
  word.list = str_split(sentence, "\\s+")
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


mydb = dbConnect(MySQL(), user='root', password='1234', dbname='yelp', host='localhost');

review = dbSendQuery(mydb, "select * from reviewData");
reviewData = fetch(review, n = -1);
reviewData["reviewScore"] <- "NA"

for(i in 1:length(reviewData$text)) {
  reviewData$reviewScore[i] <- myfunction(reviewData$text[i],pos,neg)
}

#subgrouping by business_id and caluculating the average score form given scores. review data has data of review+businessid+ businesscategory = 'Bars'


myResults <- ddply(reviewData, 
                   .(business_id,name,longitude,latitude,city, review_count),
                   summarize, 
                   averageSentimentScore = mean(reviewScore), averageRating=mean(stars)
                   )
View(myResults)
#pal is creation of the palette here with Red-Yellow-Blue colors and 8 variations of those colors.
pal<-colorQuantile("RdYlBu",NULL,n=8)
# '%>%' is composition of functions!, content is creating the info to be displayed for popup. 
content <- paste(sep = "<br/>",myResults$name,
                 paste("Rating:",format(round(myResults$averageRating,2), nsmall=2)),
                 paste("Sentiment:",format(round(myResults$averageSentimentScore,2), nsmall=2)),
                 paste("Total Reviews:",format(round(myResults$review_count,2), nsmall=2)))

map <- leaflet(myResults)%>%addTiles()%>%
  addCircleMarkers(color=~pal(myResults$averageRating),
                   popup=~content, radius = ~sqrt(myResults$review_count)*0.6, 
                   weight = 2,fillOpacity = 0.6, 
                   opacity = 0.8)%>% 
  addProviderTiles("CartoDB.Positron")

#adding the legend.
map%>%addLegend("bottomright", 
                pal = pal, 
                values = ~myResults$review_count,
                title = "Average Review Star Ratings",
                layerId = 2,
                opacity = 1)

dbDisconnect(mydb)

