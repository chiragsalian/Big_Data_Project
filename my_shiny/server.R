library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {
  
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
})