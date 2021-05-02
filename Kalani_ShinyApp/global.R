library(shiny)
library(tidyverse)
library(tidytext)
library(tidygraph)
library(wordcloud2)
library(glue)
library(fontawesome)
library(visNetwork)
library(dplyr)
library(hunspell)

DebateComments <- read_csv("debate_streaming.csv")

`%notin%` <- negate(`%in%`)

dem_words <- c("democrat", "democrats", "biden", "joe", "liberal", "liberals")
rep_words <- c("republican", "republicans", "trump", "donald", "conservative", "conservatives")
political_words <- c(dem_words, rep_words)
topic_words <- c("covid", "coronavirus", "healthcare")

DebateBigrams <- UniqueComments %>% 
  unnest_tokens(bigram, comments, token = "ngrams", n = 2, n_min = 2) %>%
  mutate(bigram = tolower(bigram))

sw <- stop_words$word

#DebateBigrams %>%
#   count(bigram, sort = TRUE)

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