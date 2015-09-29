

#Author: Jefree Breen
#https://github.com/jeffreybreen/twitter-sentiment-analysis-tutorial-201107/blob/master/R/sentiment.R

# library(plyr)
# library(stringr)

# make sure path is correct
pos = readLines("/Users/chiragsalian/Downloads/positive-words.txt");
neg = readLines("/Users/chiragsalian/Downloads/negative-words.txt");

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
