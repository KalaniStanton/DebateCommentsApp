
#################
##  LIBRARIES  ##
#################

# Standard 
library(tidyverse)
library(scales)
library(forcats)
library(data.table)

# Shiny
library(shiny)
library(shinyWidgets)
library(shinydashboard)

# Visualizations 
library(plotly)
library(ggplot2)
library(wordcloud2)

# Text
library(tidytext)
library(quanteda)
library("quanteda.dictionaries") 
library(stringi)
library(tidygraph)
library(glue)
library(fontawesome)
library(visNetwork)
library(hunspell)

# Make sure nothing is over-writing dplyr functions
library(dplyr)

###################
##  GLOBAL DATA  ##
###################

##### IMPORT THE DATA ####

debateComments <- read_csv("debate_streaming.csv")
ts.df <- read_csv('ts_df.csv')  # <------------------ data import (ts.df)

##### DATA WRANGLING FOR WORD CLOUDS ####

channel.options <- unique(ts.df$channel)
channel.options.pretty <- c("ABC","Fox","NBC")

# wordcloud aesthetics 
wordcloud_backgroundcolor <- "#F0F3F5"  # <------------------------- word cloud color options for sara
wordcloud_textpallete <- c("#e36c64","#67a9eb","#19538c","red")  # <------------------------- word cloud color options for sara
wordcloud_font <- "didot"  # <------------------------- word cloud font option for sara

# page text
vtitle <- "<h1><center>Word Usage In Comments By Channel</h1></center>"
vheader.cloud <- "The word cloud below illustrates word frequency in the comment data by size"
vpdiscription.cloud <- "Comments were tokenized, spelling corrected, and had stop words removed. The spelling check was manually verified for the top 50 words used in the comments (please see the GitHub for data mining details)."
vheader.table <- "Word frequencies by channel (descending)"
vpdiscription.table <- "This table lists word usage in the comments ranked by popularity. This is the data that is being visualized by the word cloud above."
vheader <- "Explore diction in the comments by channel: "
vpdiscription <- "The below options updates the wordcloud and table to the right based on selection."
vp1 <- "<b>Channel:</b> <br>The data captured comments from users watching presidential debate livestreams on facebook hosted by one of the major channels: ABC, Fox, or NBC. Select one of the channels below to see word frequencies used by their commenters."
vp2 <- "<b>Wordcloud Zoom in/ out:</b> <br>Use this slider to explore the wordcloud to the right. By default, the wordcloud displays all words. To view and compare the frequency of the lesser used words, increase the zoom."


#### DATA WRANGLING FOR BIGRAM NETWORK ####

`%notin%` <- negate(`%in%`)

dem_words <- c("democrat", "democrats", "biden", "joe", "liberal", "liberals")
rep_words <- c("republican", "republicans", "trump", "donald", "conservative", "conservatives")
political_words <- c(dem_words, rep_words)
topic_words <- c("covid", "coronavirus", "healthcare")

UniqueComments <- debateComments %>% distinct(text_id, .keep_all = TRUE)

DebateBigrams <- UniqueComments %>% 
  unnest_tokens(bigram, comments, token = "ngrams", n = 2, n_min = 2) %>%
  mutate(bigram = tolower(bigram))

sw <- stop_words$word

## Remove Stop Words
DebateBigrams_split <- DebateBigrams %>% 
  separate(bigram, c("word1", "word2"), sep = " ")

DebateBigrams_noSW <- DebateBigrams_split %>%
  filter(word1 %notin% sw & word2 %notin% sw) %>%
  filter(word1 %in% dem_words | word2 %in% dem_words | word1 %in% rep_words | word2 %in% rep_words) %>% 
  count(word1, word2, sort = TRUE)

DebateBigrams_wSW <- DebateBigrams_split %>% 
  filter(word1 %in% dem_words | word2 %in% dem_words | word1 %in% rep_words | word2 %in% rep_words) %>% 
  count(word1, word2, sort = TRUE)


##### DATA WRANGLING FOR SENTIMENT ####

sentiment.df <- debateComments %>%
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

sentiment_names <- unique(sentiment.df$variables)

sentiment.df$network <- substr(sentiment.df$debate, 0, 3)


##### DATA WRANGLING FOR MORAL FOUNDATIONS ####

uniqueComments <- debateComments %>% 
  distinct(text_id, .keep_all = TRUE)

debateTokens <- uniqueComments %>% 
  unnest_tokens(word, comments) 

debateTokens <- debateTokens %>% 
  anti_join(stop_words, by = "word")

debateTokens$network <- substr(debateTokens$debate, 0, 3)

debateTokens_toCorpus <- debateTokens %>%
  select(word, network) %>%
  group_by(network) %>%
  summarise(word = paste(word, collapse=" "))

debateCorpus <- corpus(debateTokens_toCorpus, docid_field = "network", text_field = "word")

output_lsd <- liwcalike(debateCorpus, 
                        dictionary = data_dictionary_MFD)


debateMSD <- output_lsd[c(1, 7:16)]
debateMSD <- gather(debateMSD, key = foundation, value = score, -docname, na.rm=FALSE)

debateMSD$score <- ifelse(grepl("vice",debateMSD$foundation),-debateMSD$score,debateMSD$score)

debateMSD <- debateMSD %>%
  separate(foundation, c("foundation", "polarity"), "[.]")

foundation_names <- unique(debateMSD$foundation)

