

shinyUI(
  navbarPage(inverse = TRUE, "🦅",
             
             # ===================== INTRODUCTION =====================
             
             tabPanel(icon("home"),
                      fluidRow(
                        column(3, p(' ')),
                        column(6, align = " center", 
                               HTML('<center><img src="live_gif.gif" alt="blinking live button" height="80"></center><p>'),
                               
                               HTML('<div style="text-align:justify;color:black;background-color:#ffe8e8;padding:15px;border:1px solid #690101;border-radius:10px">
                               <center><h1>Abstract</h1></center>      
                               This shiny app employs a few methods for visualizing the data provided by Ventura, Munger, McCabe and Chang (2021) that they discuss in their paper titled "Connective Effervescence and Streaming Chat During Political Debates." 
                               This paper discusses the semantic expressions and social dynamics within live discussions surrounding the presidential debates that preceded the 2020 election. An interactive visualization is particularly suited for this dataset due to the sheer size and semantic complexity of the domain that it encapsulates. To this end, we visualize the most frequently used words and punctuation marks using wordclouds, the proportion of "likes" associated with each sentiment across network livestream pages, and an interactive bigram network to show common word co-occurences. 
                               Additionally, we chose to incorporate an visualization for evaluating the moral sentiment present within these data by way of the Moral Foundations Dictionary (Frimer et al., 2019).</div>
                               <br>
                               <div style="text-align:justify;color:black;background-color:#edf6ff;padding:15px;border:1px solid #154473;border-radius:10px"> 
                               <center><h1>Application Components</h1></center> 
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1. Most common words (with stopwords removed) used in the Livestream comments for each news network. <br>
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2. A directional network of the most common bigrams, with seeds set as relevant buzzwords <br>
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3. Sentiments in the comments which receive the most likes <br>
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4. The frequency of moral language use in the data <br></div>
                                    <br>
                                    <div style="text-align:justify;color:black;background-color:#e6f7ff;padding:15px;border:1px solid #690101;border-radius:10px">
                                    <center><h1>Sources</h1></center> 
                                    Our data set is <a href = "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EWEJZN">https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EWEJZN</a><br>
                                    <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Frimer, J. A., Boghrati, R., Haidt, J., Graham, J., & Dehgani, M. (2019). Moral Foundations Dictionary for Linguistic Analyses 2.0. https://osf.io/xakyw/ Unpublished manuscript.<br>
                                    <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Ventura, Tiago; Munger, Kevin; McCabe, Katherine; Keng-Chi, Chang, 2021, "Replication Data for: Connective Effervescence and Streaming Chat During Political Debates", https://doi.org/10.7910/DVN/EWEJZN, Harvard Dataverse, V1
                                    </div>')
                               
                               ),
                        
                        column(3,
                               p(' ')))
                        ),
             
             # ===================== WORDCLOUDS =====================
             
             tabPanel("Common Words", fluidPage(
                        
                        # title
                        sidebarLayout(
                          sidebarPanel(
                            HTML(vtitle),
                            HTML("<center>________________________________________________</center><p>"),
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
                                        value = 1)),
                          
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
                        ))),
             
             # ===================== BIGRAM NETWORK =====================
             
             tabPanel("Bigram Network",
                      fluidPage(
                        sidebarLayout(
                          sidebarPanel(
                            HTML("<h1><center>Bigram Network Showing Word Co-occurence</h1></center>"),
                            HTML("<center>________________________________________________</center><br>"),
                            HTML("This network shows the common word co-occurences so as to enable the user to identify linguistic patterns in the data. 
                                 The network itself is comprised of edges between individual words that are found together in bigrams (with stopwords removed for clarity). 
                                 As an exploratory tool, the interactive component enables the user to identify word co-occurences for seed words pertaining to each of the two 
                                 political parties represented in these debates, enabling insight into the word associations that are common and distinctive between words that 
                                 identify both of the political parties. The edges in the graph are colored (and directed) according to their index of occurrence within the bigram; 
                                 i.e. a word that precedes a seed token will have a black edge pointing to the seed token, while one that follows is in red or blue from the seed token, 
                                 depending on the party to which that seed token refers."),
                            h3("Select Seed Tokens:"),
                            checkboxGroupInput("rep_bigrams",
                                               "Republican seed tokens:",
                                               choices = rep_words,
                                               selected = "republicans",
                                               inline = TRUE),
                            checkboxGroupInput("dem_bigrams", 
                                               "SDemocrat seed tokens:",
                                               choices = dem_words,
                                               selected = "democrats",
                                               inline = TRUE),
                            uiOutput("count_slider")),
                          
                          mainPanel(
                            h4("The network graph below shows co-occurences between selected seed tokens and other tokens found in the data (with stop words removed)."),
                            p("Edges are colored according to whether the seed token occurs before (red/blue) or after (black) each seed token in the bigram network."),
                            visNetworkOutput("polbigramnetwork", width = "100%", height = "1000px"),
                          )
                        )
                      )),
             
             # ===================== SENTIMENT =====================
             
             tabPanel("Sentiment",
                      fluidPage(
                        
                        # Application title

                        # Sidebar with a slider input for number of bins
                        sidebarLayout(
                          sidebarPanel(
                            HTML("<h1><center>Most Liked Sentiments between Networks</h1></center>"),
                            HTML("<center>________________________________________________</center><p>"),
                            selectizeInput(inputId="network", 
                                           label="Please select a network:", 
                                           choices = unique(sentiment.df$network), 
                                           selected = unique(sentiment.df$network),
                                           multiple = TRUE
                            ),
                            
                            prettyRadioButtons(
                              "option",
                              HTML("<b>What would you like to plot by?</b>"),
                              choices = list(
                                "Top Liked Sentiments" = "choose_number",
                                "Select Particular Sentiments" = "choose_sentiment"),
                              selected = "choose_number",
                              thick = FALSE,
                              animation = NULL,
                              icon = icon("smile", lib = "font-awesome")
                            ),
                            
                            conditionalPanel("input.option == 'choose_number'",
                                             sliderTextInput("numberOfSentiments",
                                                             label = "Select number of sentiment categories:",
                                                             choices = seq(1, 13, by=1),
                                                             select = 5,
                                                             grid = TRUE
                                             )
                            ),
                            conditionalPanel("input.option == 'choose_sentiment'",
                                             selectInput("sentiment_list", "Choose Sentiments",
                                                         choices = sentiment_names,
                                                         multiple = TRUE, 
                                                         selected = "Incoherent")
                            )
                            
                            
                          ),
                          
                          # Show a plot of the generated distribution
                          mainPanel(
                            h5("Here, we see the percent of likes for each network broken down by sentiment.
         While there is some variance between the networks, the trends between likes and sentiments are relatively similar."),
                            plotOutput("TotalLikesByNetworkPlot")
                          )
                        )
                      )),
             
             
             # ===================== MORAL FOUNDATIONS =====================
             
             tabPanel("Moral Language", fluidPage(
               includeCSS(path = "AdminLTE.css"),
               includeCSS(path = "shinydashboard.css"),
               theme = bslib::bs_theme(bootswatch = "simplex"),
               sidebarLayout(
                 sidebarPanel(
                   HTML("<center><h1>Moral Foundations</h1></center>"),
                   HTML("<center>________________________________________________</center><br>"),
                   HTML("Visualize the types of moral language used in Facebook livestream comments across the three major news networks!<p>"),
                    selectInput("foundation_list", HTML("<b>SELECT FOUNDATIONS TO VISUALIZE</b>"),
                                                choices = foundation_names,
                                                multiple = TRUE, 
                                                selected = "authority"), 
                   HTML("<b>WHAT IS MORAL FOUNDATIONS THEORY?</b><p>"),
                   HTML("<p align = 'justify'>Moral Foundations Theory was created by a group of social and cultural psychologists to understand why morality varies so much across cultures yet still shows so many similarities and recurrent themes. 
                   The theory proposes that at least five innate and universally available psychological systems are the foundations of 'intuitive ethics.' <a href='https://psycnet.apa.org/record/2011-01014-001'>(1)</a> 
                        Multiple studies ( <a href='https://pubmed.ncbi.nlm.nih.gov/18808272/'>2</a>, <a href='https://psycnet.apa.org/record/2009-07646-005'>3</a>, <a href='https://psycnet.apa.org/record/2009-12302-004'>4</a> ) have consistently found differences in moral language between political groups, with loyalty, authority, and sanctity having higher importance in conservative dialogues than liberal ones. 
                        These results replicate in a wide array of countries, although the plurality of studies focus on the U.S. This trend can be seen in the present data as well.</p>"),
                   HTML("<center><b>EXPLORE THE FOUNDATIONS</b></center>"),
                   
                   tabBox(
                     side = "right", 
                     width = "12",
                     height = "500px",
                     selected = "Tab3",
                     tabPanel("Care", HTML("<br><p align = 'justify'><b>Summary</b><br>This foundation is related to our long evolution as mammals with attachment systems and an ability to feel (and dislike) the pain of others. It underlies virtues of kindness, gentleness, and nurturance.</p><b>Example Words<br> <i>Virtue: </b></i>protect*, heal*, hug, relief, rescu*, patient, health*, benefit<br><b><i>Vice: </i></b>hurt, cruel, suffer*, victim*, inflict*, wound*, mistreat*")),
                     tabPanel("Fairness", HTML("<br><p align = 'justify'><b>Summary</b><br>This foundation is related to the evolutionary process of reciprocal altruism. It generates ideas of justice, rights, and autonomy.</p><b>Example Words<br> <i>Virtue: </b></i>equal, justice, tolerant, honest<br><b><i>Vice: </i></b>bias, bigot, prejud*, exclude")),
                     tabPanel("Loyalty", HTML("<br><p align = 'justify'><b>Summary</b><br>This foundation is related to our long history as tribal creatures able to form shifting coalitions. It underlies virtues of patriotism and self-sacrifice for the group. It is active anytime people feel that it’s 'one for all, and all for one.'</p><b>Example Words<br> <i>Virtue: </b></i>unison, solidarity, member, fellow, together<br><b><i>Vice: </i></b>enemy, betray, imposter, deceiv*, foreign")),
                     tabPanel("Authority", HTML("<br><p align = 'justify'><b>Summary</b><br>This foundation was shaped by our long primate history of hierarchical social interactions. It underlies virtues of leadership and followership, including deference to legitimate authority and respect for traditions.</p><b>Example Words<br> <i>Virtue: </b></i>obey, status, honor, duty<br><b><i>Vice: </i></b>illegal, unfaithful, protest, refuse, riot")),
                     tabPanel("Sanctity", HTML("<br><p align = 'justify'><b>Summary</b><br>This foundation was shaped by the psychology of disgust and contamination. It underlies religious notions of striving to live in an elevated, less carnal, more noble way. It underlies the widespread idea that the body is a temple which can be desecrated by immoral activities and contaminants (an idea not unique to religious traditions).</p><b>Example Words<br> <i>Virtue: </b></i>pure, holy, virtue, innocent, righteous<br><b><i>Vice: </i></b>sin, lewd, depraved, indecent, wicked"))
                   )
                   
                 ), #Sidebar end 
                 
                 mainPanel(
                   
                   plotOutput("mfd"),
                   
                   fluidRow(
                     tags$br()
                   ),
                   
                   fluidRow(
                      infoBox("ABC: % Moral Language", "9.86%", icon = icon("video"), fill = TRUE, color = "blue"),
                      infoBox("Fox: % Moral Language", "13.22%", icon = icon("firefox"), fill = TRUE, color = "red"),
                      infoBox("NBC: % Moral Language", "10.13%", icon = icon("feather-alt"), fill = TRUE, color = "blue"),
                   )
                   
                 ), 
                 
               )))
             
  )) # UI end