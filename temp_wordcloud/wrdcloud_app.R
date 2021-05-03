library(shiny)
library(wordcloud2)
library(tidyverse)

datapath <- '/Users/viv/Downloads/DATA'

# ================================ MAIN =======================================
ts.df <- read_csv(file.path('ts_df.csv'))  # <------------------ data import (ts.df)
channel.options <- unique(ts.df$channel)
channel.options.pretty <- c("ABC","Fox","NBC")

# wordcloud aesthetics 
wordcloud_backgroundcolor <- "#F0F3F5"  # <------------------------- word cloud color options for sara
wordcloud_textpallete <- c("#181D27","#272F3F","#08090D","#2D334E")  # <------------------------- word cloud color options for sara
wordcloud_font <- "didot"  # <------------------------- word cloud font option for sara

# page text
vtitle <- "Word Usage In Comments By Channel"

vheader.cloud <- "The word cloud below illustrates word frequency in the comment data by size"
vpdiscription.cloud <- "Comments were tokenized, spelling corrected, and had stop words removed. The spelling check was manually verified for the top 50 words used in the comments (please see the GitHub for data mining details)."
vheader.table <- "Word frequencies by channel (descending)"
vpdiscription.table <- "This table lists word usage in the comments ranked by popularity. This is the data that is being visualized by the word cloud above."
  
vheader <- "Explore diction in the comments by channel: "
vpdiscription <- "The below options updates the wordcloud and table to the right based on selection."
vp1 <- "<b>Channel:</b> <br>The data captured comments from users watching presidential debate livestreams on facebook hosted by one of the major channels: ABC, Fox, or NBC. Select one of the channels below to see word frequencies used by their commenters."
vp2 <- "<b>Wordcloud Zoom in/ out:</b> <br>Use this slider to explore the wordcloud to the right. By default, the wordcloud displays all words. To view and compare the frequency of the lesser used words, increase the zoom."



# ================================ UI =======================================
ui <- fluidPage(
  
  # title
  titlePanel(vtitle),
  
  sidebarLayout(
    
    # options
    sidebarPanel(
      
      h4(vheader),
      p(vpdiscription),
      HTML("<br>"),
      
      HTML(vp1),
      selectInput("usr.channel", 
                  "",
                  choices = channel.options.pretty,
                  selected = "ABC"),
      HTML("<br><br>"),
      
      HTML(vp2),
      sliderInput("usr.zoom",
                  "",
                  min = 1,
                  max = 10,
                  value = 1)
    ),
    
    # cloud and table
    mainPanel(
      
      h4(vheader.cloud),
      p(vpdiscription.cloud),
      wordcloud2Output("wcloud"),
      HTML("<br><br>"),
      
      h4(vheader.table),
      p(vpdiscription.table),
      dataTableOutput('table')
    )
  )
)


# ================================ SERVER =======================================
server <- function(input, output, session) {
  output$wcloud <- renderWordcloud2({
    usr.channel.no <- which(channel.options.pretty == input$usr.channel)
    temp.tab <- ts.df %>% 
      filter(channel == channel.options[usr.channel.no]) %>% 
      select(correction) %>% count(correction, name = "freq") %>%
      arrange(desc(freq))
    
    temp.tab %>% wordcloud2(fontFamily = wordcloud_font, 
                            size = input$usr.zoom,  # <--------------- adjustable parameter "zoom" [1, 10]
                            minSize = 3,
                            rotateRatio = .15,
                            gridSize = 7.5,
                            ellipticity = 1,
                            backgroundColor = wordcloud_backgroundcolor,
                            color = wordcloud_textpallete)
  })
  
  output$table <- renderDataTable({
    usr.channel.no <- which(channel.options.pretty == input$usr.channel)
    temp.tab <- ts.df %>% 
      filter(channel == channel.options[usr.channel.no]) %>%
      select(correction) %>%
      count(correction, name = "Frequency") %>%
      arrange(desc(Frequency)) %>%
      rename(c("Word" = "correction")) %>%
      mutate(Proportion = paste0(round (Frequency / sum(Frequency) * 100, digits = 1), "%"))
  })
}


# ================================ APP CALL =======================================
shinyApp(ui, server)