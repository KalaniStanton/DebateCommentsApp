#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sentiments of Most Liked Comments between Networks"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("network",
                        label = "Please select a network:",
                        choices = unique(sentiment.df$network)
                        # value = "abc")
                        ),
            
            sliderInput("numberOfSentiments",
                        label = "Select number of sentiment categories:",
                        max=length(unique(sentiment.df$variables)),
                        min = 1,
                        value = 5)
            
            ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("TotalLikesByNetworkPlot")
        )
    )
))
