


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Most Liked Sentiments between Networks"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectizeInput(inputId="network", 
                     label="Please select a network:", 
                     choices = unique(sentiment.df$network), 
                     selected = unique(sentiment.df$network),
                     multiple = TRUE
                     ),
      
      
      sliderInput("numberOfSentiments",
                  label = "Select number of sentiment categories:",
                  max=length(unique(sentiment.df$variables)),
                  min = 1,
                  value = 5)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h5("Here, we see the proportion of likes for each network broken down by sentiment.
         While there is some variance between the networks, the trends between likes and sentiments are relatively similar."),
      plotOutput("TotalLikesByNetworkPlot")
    )
  )
))

































