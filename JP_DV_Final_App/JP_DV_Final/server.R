library(shiny)

library(scales)


# GLOBAL.R

sentiment.df <- comments %>%
  group_by(text_id) %>%
  filter(scores == max(scores)) 

sentiment.df <- sentiment.df %>%
  group_by(variables)%>%
  mutate(total_likes = sum(likes, na.rm=TRUE), sentiment = fct_lump(variables, n=5))



sentiment.df$variables[sentiment.df$variables == "INCOHERENT"] <- "Incoherent"
sentiment.df$variables[sentiment.df$variables == "UNSUBSTANTIAL"] <- "Unsubstantial"
sentiment.df$variables[sentiment.df$variables == "INSULT"] <- "Insult"
sentiment.df$variables[sentiment.df$variables == "OBSCENE"] <- "Obscene"
sentiment.df$variables[sentiment.df$variables == "LIKELY_TO_REJECT"] <- "Likely to Reject"
sentiment.df$variables[sentiment.df$variables == "INFLAMMATORY"] <- "Threat"
sentiment.df$variables[sentiment.df$variables == "ATTACK_ON_COMMENTER"] <- "Attack on Commenter"
sentiment.df$variables[sentiment.df$variables == "THREAT"] <- "Threat"
sentiment.df$variables[sentiment.df$variables == "ATTACK_ON_AUTHOR"] <- "Attack on Author"
sentiment.df$variables[sentiment.df$variables == "IDENTITY_ATTACK"] <- "Incoherent"
sentiment.df$variables[sentiment.df$variables == "SPAM"] <- "Spam"
sentiment.df$variables[sentiment.df$variables == "FLIRTATION"] <- "Flirtation"
sentiment.df$variables[sentiment.df$variables == "TOXICITY"] <- "Toxicity"
sentiment.df$variables[sentiment.df$variables == "PROFANITY"] <- "Profanity"
sentiment.df$variables[sentiment.df$variables == "SEXUALLY_EXPLICIT"] <- "Sexually Explicit"

require(stringi)
sentiment.df$network <- substr(sentiment.df$debate, 0, 3)

# END GLOBAL.R

shinyServer(function(input, output) {
  
  networkData <- eventReactive(input$network, {
    myNetwork <- input$network
    df <- sentiment.df %>% 
      group_by(network) %>%
      mutate(Percent = 100*(likes/sum(likes, na.rm=TRUE))) %>%
      filter(network %in% myNetwork)
  })
  
  output$TotalLikesByNetworkPlot <- renderPlot({
    df <- networkData()
    ggplot(df, aes(x=fct_infreq(fct_lump(variables, n=input$numberOfSentiments)), y=Percent, fill=network)) + 
      geom_bar(stat='identity', position='dodge') +
      ylab("Proportion of Likes") +
      xlab("Sentiment") +
      theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) +
      scale_y_continuous(limits = c(0,50),
                         labels=number_format(
                           suffix="%")) +
      scale_fill_manual(values = c("green", "blue", "red"))
  })
  
})
