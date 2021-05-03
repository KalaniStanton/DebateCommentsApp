
#################
##  LIBRARIES  ##
#################

library(shiny)
library(shinyWidgets)
library(tidyverse)
library(plotly)
library(tidytext)
library(quanteda)
library("quanteda.dictionaries") 
library(stringi)
library(ggplot2)

###################
##  GLOBAL DATA  ##
###################

debateComments <- read_csv("debate_streaming.csv")

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

