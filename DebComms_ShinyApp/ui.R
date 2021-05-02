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
shinyUI(
    fluidPage(
      
      titlePanel("Bigram Network Showing Word Co-occurence"),
      
      sidebarLayout(
                  sidebarPanel(
                    h3("Select Seed Tokens:"),
                      checkboxGroupInput("rep_bigrams",
                                         "Republican seed tokens:",
                                         choices = rep_words,
                                         selected = "republicans",
                                         inline = TRUE),
                      checkboxGroupInput("dem_bigrams", 
                                         "SDemocrat seed tokens:",
                                         choices = dem_words,
                                         selected = "democrats",
                                         inline = TRUE),
                      uiOutput("count_slider")),
                      
                  mainPanel(
                      h4("The network graph below shows co-occurences between selected seed tokens and other tokens found in the data (with stop words removed)."),
                      p("Edges are colored according to whether the seed token occurs before (red/blue) or after (black) each seed token in the bigram network."),
                      visNetworkOutput("polbigramnetwork", width = "100%", height = "1000px"),
                      )
                  )
             ))
