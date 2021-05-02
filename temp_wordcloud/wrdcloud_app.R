library(shiny)
library(wordcloud2)
library(tidyverse)

datapath <- '/Users/viv/Downloads/DATA'

# MAIN
ts.df <- read_csv(file.path('ts_df.csv'))  # <------------------ data import (ts.df)
channel.options <- unique(ts.df$channel)
channel.options.pretty <- c("ABC","Fox","NBC")
wordcloud_backgroundcolor <- "#F0F3F5"  # <------------------------- color options for sara
wordcloud_textpallete <- c("#181D27","#272F3F","#08090D","#2D334E")  # <------------------------- color options for sara

# UI
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("usr.zoom",
                  "Word Cloud Zoom in/ out: ",
                  min = 1,
                  max = 10,
                  value = 1),
      selectInput("usr.channel", 
                  "Channel:",
                  choices = channel.options.pretty,
                  selected = "ABC")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      wordcloud2Output("wcloud"),
      HTML("<br><br><br>"),
      dataTableOutput('table')
    )
  )
)

# SERVER
server <- function(input, output, session) {
  output$wcloud <- renderWordcloud2({
    usr.channel.no <- which(channel.options.pretty == input$usr.channel)
    temp.tab <- ts.df %>% 
      filter(channel == channel.options[usr.channel.no]) %>% 
      select(correction) %>% count(correction, name = "freq") %>%
      arrange(desc(freq))
    
    temp.tab %>% wordcloud2(fontFamily = "didot", 
                            size = input$usr.zoom,  # <--------------- adjustable parameter "zoom" [1, 10]
                            minSize = 3,
                            rotateRatio = .15,
                            gridSize = 7.5,
                            ellipticity = 1,
                            backgroundColor = wordcloud_backgroundcolor,
                            color = wordcloud_textpallete)
  })
  
  output$table <- renderDataTable({
    temp.tab <- ts.df %>% 
      filter(channel == channel.options[usr.channel.no]) %>%
      select(correction) %>%
      count(correction, name = "Frequency") %>%
      arrange(desc(Frequency)) %>%
      rename(c("correction" = "Word")) %>%
      mutate(Proportion = paste0(round (Frequency / sum(Frequency) * 100, digits = 1), "%"))
  })
}

shinyApp(ui, server)