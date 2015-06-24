library(shiny)
library(wordcloud)
library(RColorBrewer)

terms <- c('this', 'is', 'a', 'test', 'of', 'my', 'auto', 'complete', 'app', 'dont', 'judge', 'me', 
           'dude', 'you', 'wouldnt', 'be', 'able', 'to', 'do', 'any', 'better')
term_count <- c(95, 94, 93, 82, 78, 77, 77, 70, 64, 60, 52, 50, 49, 43, 42, 41, 35, 23, 12, 6, 5)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot

    output$wordCloud <- renderPlot({
        # draw the histogram with the specified number of bins
        wordcloud(terms[1:input$count], term_count[1:input$count], colors=brewer.pal(8, 'Dark2'))
    })
    
    output$probabilities <- renderTable({
        # create a table of probabilties for each predicted term
        p <- data.frame(terms[1:input$count], term_count[1:input$count])
        colnames(p) <- c("terms", "count")
        p
    })
})