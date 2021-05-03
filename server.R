
library(shiny)
library(shinyWidgets)
library(tidyverse)
library(plotly)

shinyServer(
  function(input, output, session) {
    
    observeEvent(list(input$foundation_list), {
      foundation_names <- debateMSD %>% filter(foundation %in% input$foundation_list)
      updateSelectInput(session, "foundation",
                        choices = foundation_names,
                        selected = "authority")
    })
    
    ###############
    ## THE DATA  ##
    ###############

    df <- reactive({
      
      my_df <- debateMSD %>%
        filter(foundation %in% input$foundation_list)
      
    })
    
    ###############
    ##  OUTPUTS  ##
    ###############
    
    
    observe(
      output$mfd <- renderPlot({
        
        validate(
          need(input$foundation_list != "", "Please select a foundation!"))
        
        # Normal ggplot construction time ~
        
        df() %>%
          ggplot(aes(foundation, score, fill = polarity)) +
          geom_col(show.legend = TRUE) +
          geom_abline(slope=0, intercept=0,  col = "black", lty = 1) + 
          scale_fill_manual(values=c('mediumpurple3', 'plum2')) + 
          scale_y_continuous(labels = function(x){paste0(abs(x), "%")}) + 
          geom_text(aes(label = scales::percent(round(abs(score/100),3))), 
                    #position = position_dodge2(preserve = "single", width = -.9, padding = 0.1),
                    hjust = .5,
                    vjust = 1.3,
                    size = 5) + 
          labs(title = "Moral Foundations across Livestreams", 
               subtitle = " ",
               x = "Foundation", 
               y = "Percent of Words") + 
          facet_wrap(~docname) + 
          coord_cartesian(ylim = c(-2, 4)) + 
          theme(text=element_text(size=15), 
                axis.title.y = element_text(vjust=2), 
                axis.title.x = element_text(vjust=-.5), 
                plot.title = element_text(hjust = 0.5, vjust = 1, size = 30),
                plot.subtitle = element_text(hjust = 0.5, vjust = 3),
                strip.background =element_rect(fill="lavender")
                )
        
        }))
    
  }
)

