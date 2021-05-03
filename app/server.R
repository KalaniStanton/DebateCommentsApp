
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

    morality_df <- reactive({
      
      my_df <- debateMSD %>%
        filter(foundation %in% input$foundation_list)
      
    })
    
    
    #########################
    ##  WORDCLOUD OUTPUTS  ##
    #########################
    
    output$wcloud <- renderWordcloud2({
      
      usr.channel.no <- which(channel.options.pretty == input$usr.channel)
      
      temp.tab <- ts.df %>% 
        filter(channel == channel.options[usr.channel.no]) %>% 
        select(correction) %>% count(correction, name = "freq") %>%
        arrange(desc(freq))
      
      temp.tab %>% 
        wordcloud2(fontFamily = wordcloud_font, 
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
      output_table <- ts.df %>% 
        filter(channel == channel.options[usr.channel.no]) %>%
        select(correction) %>%
        count(correction, name = "Frequency") %>%
        arrange(desc(Frequency)) %>%
        rename(c("Word" = "correction")) %>%
        mutate(Percent = paste0(round (Frequency / sum(Frequency) * 100, digits = 1), "%"))
    })
    
    ########################
    ## SENTIMENT OUTPUTS  ##
    ########################
      
    
    networkData <- eventReactive(input$network, {
        df <- sentiment.df %>% 
          group_by(network) %>%
          mutate(Percent = 100*(likes/sum(likes, na.rm=TRUE))) %>%
          filter(network %in% input$network)
      })
    
    output$TotalLikesByNetworkPlot <- renderPlot({
    
    networkColors <- c("abc" = "skyblue1", "fox" = "red", "nbc" = "dodgerblue3")
      
    if (input$option == "choose_number"){
      
      networkData() %>%
      ggplot(aes(x=fct_infreq(fct_lump(variables, n=input$numberOfSentiments)), y=Percent, fill=network)) + 
        geom_bar(stat='identity', position='dodge') +
        ylab("Percent of Likes") +
        xlab("Sentiment") +
        labs(
          title = "Percent of Likes per Sentiment",
          subtitle = "Across Facebook Comments on Livestreams across Three Major News Networks"
        ) + 
        theme(
          text=element_text(size=15), 
          axis.title.y = element_text(vjust=2), 
          axis.title.x = element_text(vjust=-.5), 
          axis.text.x = element_text(angle=45, vjust=1, hjust=1, size = 12),
          plot.title = element_text(hjust = 0.5, vjust = 1, size = 30),
          plot.subtitle = element_text(hjust = 0.5, vjust = 3),
        ) +
        scale_y_continuous(limits = c(0,2),
                           labels=number_format(
                             suffix="%")) +
        scale_fill_manual(values = networkColors)
    } else {
      networkData() %>%
        filter(variables %in% input$sentiment_list) %>%
        ggplot(aes(x=variables, y=Percent, fill=network)) + 
          geom_bar(stat='identity', position='dodge') +
          ylab("Percent of Likes") +
          xlab("Sentiment") +
          labs(
            title = "Percent of Likes per Sentiment",
            subtitle = "Across Facebook Comments on Livestreams across Three Major News Networks"
          ) + 
          theme(
            text=element_text(size=15), 
            axis.title.y = element_text(vjust=2), 
            axis.title.x = element_text(vjust=-.5), 
            axis.text.x = element_text(angle=45, vjust=1, hjust=1, size = 12),
            plot.title = element_text(hjust = 0.5, vjust = 1, size = 30),
            plot.subtitle = element_text(hjust = 0.5, vjust = 3),
          ) +
          scale_y_continuous(limits = c(0,2),
                           labels=number_format(
                             suffix="%")) +
          scale_fill_manual(values = networkColors)
      
      
    }
    })
    
    #######################
    ## MORALITY OUTPUTS  ##
    #######################
    
    
    observe(
      output$mfd <- renderPlot({
        
        # -- Default message if no foundation is selected -- 
        validate(
          need(input$foundation_list != "", "Please select a foundation!"))
        
        # -- Normal ggplot construction time! -- 
        
        network.labs = c("ABC", "NBC", "Fox")
        names(network.labs) = c("abc", "nbc", "fox")
        
        morality_df() %>%
          ggplot(aes(foundation, score, fill = polarity)) +
          geom_col(show.legend = TRUE) +
          geom_abline(slope=0, intercept=0,  col = "black", lty = 1) + 
          scale_fill_manual(values=c('dodgerblue3', 'skyblue1'), 
                            labels = c("Vice (-)", "Virtue (+)")) + 
          scale_y_continuous(labels = function(x){paste0(abs(x), "%")}) + 
          scale_x_discrete(labels=c("authority" = "Authority", "loyalty" = "Loyalty",
                                    "fairness" = "Fairness", "care" = "Care", "sanctity" = "Sanctity")) + 
          geom_text(aes(label = scales::percent(round(abs(score/100),3))), 
                    #position = position_dodge2(preserve = "single", width = -.9, padding = 0.1),
                    hjust = .5,
                    vjust = 1.3,
                    size = 5) + 
          labs(title = "Moral Foundations across Livestreams", 
               subtitle = " ",
               x = "Foundation", 
               y = "Percent of Words",
               fill = "Polarity") + 
          facet_wrap(~docname, labeller = labeller(docname = network.labs)) + 
          coord_cartesian(ylim = c(-2, 4)) + 
          theme(text=element_text(size=15), 
                axis.title.y = element_text(vjust=2), 
                axis.title.x = element_text(vjust=-.5), 
                plot.title = element_text(hjust = 0.5, vjust = 1, size = 30),
                plot.subtitle = element_text(hjust = 0.5, vjust = 3),
                strip.background =element_rect(fill="indianred"),
                strip.text = element_text(size = 15, colour = "white")
                )
        
        }))
    

    #######################
    ##  NETWORK OUTPUTS  ##
    #######################
    
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
      req(input$count_min)
      DebateBigrams_noSW %>%
        filter(word1 %in% input$rep_bigrams | word2 %in% input$rep_bigrams | word1 %in% input$dem_bigrams | word2 %in% input$dem_bigrams) %>% 
        filter(n >= input$count_min) %>%
        as_tbl_graph() %>% 
        mutate(color.background = if_else(name %in% input$rep_bigrams, "#E00008", if_else(name %in% input$dem_bigrams, "#000ce8", "#E00008")),
               color.border = if_else(name %in% input$rep_bigrams, "#E00008", if_else(name %in% input$dem_bigrams, "#000ce8", "#E00008")),
               label = name,
               labelHighlightBold = TRUE,
               font.face = "Courier",
               font.size = if_else(name %in% input$rep_bigrams | name %in% input$rep_bigrams, 80, 40),
               font.color = if_else(name %in% input$rep_bigrams, "#E00008", if_else(name %in% input$dem_bigrams, "#000ce8", "black")),
               shape = if_else(name %in% input$rep_bigrams | name %in% input$dem_bigrams, "icon", "dot"),
               icon.face = "FontAwesome",
               icon.code = "f111",
               icon.size = if_else(name %in% input$rep_bigrams | name %in% input$dem_bigrams, 125, 75),
               icon.color = if_else(name %in% input$dem_bigrams, "#000ce8", if_else(name %in% input$rep_bigrams, "#E00008", "black"))) %>% 
        activate(edges) %>% 
        mutate(hoverWidth = n/50,
               selectionWidth = n/50,
               scaling.max = 5)
    })
    
    output$polbigramnetwork <- renderVisNetwork({
      
      visIgraph(bigram_graph_data()) %>% 
        visInteraction(hover = TRUE, tooltipDelay = 0) %>% 
        addFontAwesome()
      
    })
    
  }
)

