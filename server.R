library(shiny)
library(wordcloud)
library(RColorBrewer)

source('load_data.R')
source('prediction.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot

    # filter out extra spaces, leading and trailing spaces, non alpha-numeric and space characters, and
    # curse words.
    
    output$wordCloud <- renderPlot({
        # draw the histogram with the specified number of bins
        predicted_terms <- predict_terms(input$phrase)
        count <- min(nrow(predicted_terms), input$count)
        wordcloud(predicted_terms$term[1:count], predicted_terms$probability[1:count], 
                  colors=brewer.pal(8, 'Dark2'), scale=c(8,1))
    })
    
    #output$probabilities <- renderTable({
        # create a table of probabilties for each predicted term
    #    predicted_terms[1:input$count]
    #})
})