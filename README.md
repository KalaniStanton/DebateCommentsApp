# Debate Comments App

**Abstract**
This shiny app employs a few methods for visualizing the data provided by Ventura, Munger, McCabe and Chang (2021) that they discuss in their paper titled "Connective Effervescence and Streaming Chat During Political Debates." This paper discusses the semantic expressions and social dynamics within live discussions surrounding the presidential debates that preceded the 2020 election. An interactive visualization is particularly suited for this dataset due to the sheer size and semantic complexity of the domain that it encapsulates. To this end, we visualize the most frequently used words and punctuation marks using wordclouds, the proportion of "likes" associated with each sentiment across network livestream pages, and an interactive bigram network to show common word co-occurences. Additionally, we chose to incorporate an visualization for evaluating the moral sentiment present within these data by way of the Moral Foundations Dictionary (Frimer et al., 2019).




## Application Components

### Wordcloud (Most Frequent Tokens)

The wordcloud is meant to illustrate the most frequently used unigram tokens, with an interactive feature that allows the user to "zoom-in" and see words with lower frequency by excluding the most common tokens determined by the slider on the left.

### Bigram Co-occurence Network

This network shows the common word co-occurences so as to enable the user to identify linguistic patterns in the data. The network itself is comprised of edges between individual words that are found together in bigrams (with stopwords removed for clarity). As an exploratory tool, the interactive component enables the user to identify word co-occurences for seed words pertaining to each of the two political parties represented in these debates, enabling insight into the word associations that are common and distinctive between words that identify both of the political parties. The edges in the graph are colored (and directed) according to their index of occurrence within the bigram; i.e. a word that precedes a seed token will have a black edge pointing to the seed token, while one that follows is in red or blue from the seed token, depending on the party to which that seed token refers.

### Sentiment Approval

This plot shows the proportions of the total likes received by each network attributed to each of the sentiment categories. The user is provided a list of three major cable news networks from which they can choose any number of networks to plot in a side by side bar chart. Additionally, the user can use the slider to select the top number of sentiments they would like to plot based on their respective likes (using factor lump).

### Moral Foundations Sentiment

Moral Foundations Theory was created by a group of social and cultural psychologists to understand why morality varies so much across cultures yet still shows so many similarities and recurrent themes. The theory proposes that at least five innate and universally available psychological systems are the foundations of “intuitive ethics.” (1) Multiple studies (2) have consistently found differences in moral language between political groups, with loyalty, authority, and sanctity having higher importance in conservative dialogues than liberal ones. These results replicate in a wide array of countries (3), although the plurality of studies focus on the U.S. This trend can be seen in the present data as well.

## Data Source

Our data set is 
https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EWEJZN


Frimer, J. A., Boghrati, R., Haidt, J., Graham, J., & Dehgani, M. (2019). *Moral Foundations Dictionary for Linguistic Analyses 2.0*. https://osf.io/xakyw/ Unpublished manuscript.

Ventura, Tiago; Munger, Kevin; McCabe, Katherine; Keng-Chi, Chang, 2021, "Replication Data for: Connective Effervescence and Streaming Chat During Political Debates", https://doi.org/10.7910/DVN/EWEJZN, Harvard Dataverse, V1 
