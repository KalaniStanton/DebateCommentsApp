library(shiny)

library(scales)


sentiment.df <- comments %>%
    group_by(text_id) %>%
    filter(scores == max(scores)) 

sentiment.df <- sentiment.df %>%
    group_by(variables)%>%
    mutate(total_likes = sum(likes, na.rm=TRUE), sentiment = fct_lump(variables, n=5))

# # Recode Sentiment Categories
# require(forcats)
# fct_recode(sentiment.df$variables, "Incoherent"="INCOHERENT", 
#            "Unsubstantial"="UNSUBSTANTIAL", 
#            "Insult" = "INSULT", 
#            "Obscene"="OBSCENE", 
#            "Likely to Reject"="LIKELY_TO_REJECT", 
#            "Inflammatory"="INFLAMMATORY", 
#            "Attack on Commenter"="ATTACK_ON_COMMENTER", 
#            "Threat"="THREAT", 
#            "Attack on Author" = "ATTACK_ON_AUTHOR", 
#            "Identity Attack" = "IDENTITY_ATTACK", 
#            "Spam"="SPAM", "Flirtation"="FLIRTATION", 
#            "Toxicity"="TOXICITY", 
#            "Profanity"="PROFANITY", 
#            "Sexually Explicit"="SEXUALLY_EXPLICIT")

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



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    networkData <- eventReactive(input$network, {
        myNetwork <- input$network
        df <- sentiment.df %>% 
                group_by(network) %>%
                mutate(Percent = 100*(likes/sum(likes, na.rm=TRUE))) %>%
                filter(network == myNetwork)
    })

    output$TotalLikesByNetworkPlot <- renderPlot({
        df <- networkData()
        recode(df$variables, "Attack" = "ATTACK_ON_COMMENTER", "Attack" = "ATTACK_ON_AUTHOR", "Attack"="IDENTITY_ATTACK")
        ggplot(df, aes(x=fct_infreq(fct_lump(variables, n=input$numberOfSentiments)), y=Percent)) + 
            geom_bar(stat='identity') +
            ylab("Proportion of Likes") +
            xlab("Sentiment") +
            theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) +
            scale_y_continuous(limits = c(0,50),
                               labels=number_format(
                                   suffix="%"))
        # plot(sentiment.df$sentiment, sentiment.df$total_likes)

        # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })

})
