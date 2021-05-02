#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    output$count_slider <- renderUI({
        max_tmp <- DebateBigrams_noSW %>%
            filter(word1 %in% input$rep_bigrams | word2 %in% input$rep_bigrams | word1 %in% input$dem_bigrams | word2 %in% input$dem_bigrams) %>%
            select(n)
        sliderInput("count_min", 
                    "Select Minimum Frequency of Bigram:",
                    min = 1,
                    max = max(max_tmp),
                    value = 2,
                    round = TRUE)
    })
    
    bigram_graph_data <- reactive({
        #req(input$rep_bigrams)
        #req(input$dem_bigrams)
        req(input$count_min)
        DebateBigrams_noSW %>%
            filter(word1 %in% input$rep_bigrams | word2 %in% input$rep_bigrams | word1 %in% input$dem_bigrams | word2 %in% input$dem_bigrams) %>% 
            filter(n >= input$count_min) %>%
            as_tbl_graph() %>% 
            mutate(color.background = if_else(name %in% input$rep_bigrams, "#E00008", if_else(name %in% input$dem_bigrams, "#000ce8", "#E00008")),
                   color.border = if_else(name %in% input$rep_bigrams, "#E00008", if_else(name %in% input$dem_bigrams, "#000ce8", "#E00008")),
                   label = name,
                   labelHighlightBold = TRUE,
                   #size = if_else(name  "love", 70, 25),
                   font.face = "Courier",
                   font.size = if_else(name %in% input$rep_bigrams | name %in% input$rep_bigrams, 80, 40),
                   font.color = if_else(name %in% input$rep_bigrams, "#E00008", if_else(name %in% input$dem_bigrams, "#000ce8", "black")),
                   shape = if_else(name %in% input$rep_bigrams | name %in% input$dem_bigrams, "icon", "dot"),
                   icon.face = "FontAwesome",
                   icon.code = "f111",
                   icon.size = if_else(name %in% input$rep_bigrams | name %in% input$dem_bigrams, 125, 75),
                   icon.color = if_else(name %in% input$dem_bigrams, "#000ce8", if_else(name %in% input$rep_bigrams, "#E00008", "black"))) %>% 
            activate(edges) %>% 
            mutate(hoverWidth = n,
                   selectionWidth = n,
                   scaling.max = 5)
    })
    
    output$polbigramnetwork <- renderVisNetwork({
        
        visIgraph(bigram_graph_data()) %>% 
            visInteraction(hover = TRUE, tooltipDelay = 0) %>% 
            addFontAwesome()
        
    })
})
