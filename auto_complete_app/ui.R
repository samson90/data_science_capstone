library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Auto-complete App"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            p("Enter a phrase below and I'll predict the next word."),
            textInput("phrase", label="") ,
            sliderInput("count",
                        "Number of terms:",
                        min = 1,
                        max = 20,
                        value = 1),
            tableOutput("probabilities")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("wordCloud")
        )
    )
))