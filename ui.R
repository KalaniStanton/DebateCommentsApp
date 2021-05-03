
library(shiny)
library(shinyWidgets)
library(tidyverse)
library(plotly)
library(shinydashboard)

shinyUI(
  navbarPage(inverse = TRUE, "🌎",
             
             # INTRODUCTION PANEL
             
             tabPanel("Introduction",
                      headerPanel(HTML('<center><h1 style = "font-family:Georgia, serif;"><b>Introduction</b></h1></center>')),
                      fluidRow(
                        column(3, p(' ')),
                        column(6, align = " center", 
                               p('This is an introduction page! I thought it would be fun to mess around with tabs to get familiarized
                       with them before the final project. It was pretty fun. This is just some more text to bulk up this page. 
                       I think I may try and put in a gif. If this were a formal project, I would introduce the topic here. Maybe
                       put a thesis statement. Explain what is going on in the other tabs. But here is some text instead.'),
                               HTML('<center><img src="spin_gif.gif" alt="Im a globe!" height="200"></center>'),
                               HTML('<p><i><center>Source: Giphy.com</p></i></center>')),
                        column(3,
                               p(' ')))),
             
             # WHAT IS BEING SAID?
             
             tabPanel("Plot", fluidPage(
               includeCSS(path = "AdminLTE.css"),
               includeCSS(path = "shinydashboard.css"),
               theme = bslib::bs_theme(bootswatch = "minty"),
               headerPanel(HTML('<center><h1 style = "font-family:Georgia, serif;"><b>Moral Language</b></h1></center> <br>')),
               sidebarLayout(
                 sidebarPanel(
                   HTML("<center><h2>Moral Foundations</h2></center>"),
                   
                    selectInput("foundation_list", HTML("<b>SELECT FOUNDATIONS TO VISUALIZE</b>"),
                                                choices = foundation_names,
                                                multiple = TRUE, 
                                                selected = "authority"), 
                   HTML("<b>WHAT IS MORAL FOUNDATIONS THEORY?</b><p>"),
                   HTML("<p align = 'justify'>Moral Foundations Theory was created by a group of social and cultural psychologists to understand why morality varies so much across cultures yet still shows so many similarities and recurrent themes. The theory proposes that at least five innate and universally available psychological systems are the foundations of “intuitive ethics.” (1) Multiple studies (2) have consistently found differences in moral language between political groups, with loyalty, authority, and sanctity having higher importance in conservative dialogues than liberal ones. These results replicate in a wide array of countries (3), although the plurality of studies focus on the U.S. This trend can be seen in the present data as well.</p>"),
                   HTML("<center><b>EXPLORE THE FOUNDATIONS</b></center>"),
                   
                   tabBox(
                     side = "right", 
                     width = "12",
                     height = "500px",
                     selected = "Tab3",
                     tabPanel("Care", HTML("<br><p align = 'justify'><b>Summary</b><br>This foundation is related to our long evolution as mammals with attachment systems and an ability to feel (and dislike) the pain of others. It underlies virtues of kindness, gentleness, and nurturance.</p><b>Example Words<br> <i>Virtue: </b></i>protect*, heal*, hug, relief, rescu*, patient, health*, benefit<br><b><i>Vice: </i></b>hurt, cruel, suffer*, victim*, inflict*, wound*, mistreat*")),
                     tabPanel("Fairness", HTML("<br><p align = 'justify'>This foundation is related to the evolutionary process of reciprocal altruism. It generates ideas of justice, rights, and autonomy.</p><b>Example Words<br> <i>Virtue: </b></i>equal, justice, tolerant, honest<br><b><i>Vice: </i></b>bias, bigot, prejud*, exclude")),
                     tabPanel("Loyalty", HTML("<br><p align = 'justify'>This foundation is related to our long history as tribal creatures able to form shifting coalitions. It underlies virtues of patriotism and self-sacrifice for the group. It is active anytime people feel that it’s 'one for all, and all for one.'</p><b>Example Words<br> <i>Virtue: </b></i>unison, solidarity, member, fellow, together<br><b><i>Vice: </i></b>enemy, betray, imposter, deceiv*, foreign")),
                     tabPanel("Authority", HTML("<br><p align = 'justify'>This foundation was shaped by our long primate history of hierarchical social interactions. It underlies virtues of leadership and followership, including deference to legitimate authority and respect for traditions.</p><b>Example Words<br> <i>Virtue: </b></i>obey, status, honor, duty<br><b><i>Vice: </i></b>illegal, unfaithful, protest, refuse, riot")),
                     tabPanel("Sanctity", HTML("<br><p align = 'justify'>This foundation was shaped by the psychology of disgust and contamination. It underlies religious notions of striving to live in an elevated, less carnal, more noble way. It underlies the widespread idea that the body is a temple which can be desecrated by immoral activities and contaminants (an idea not unique to religious traditions).</p><b>Example Words<br> <i>Virtue: </b></i>pure, holy, virtue, innocent, righteous<br><b><i>Vice: </i></b>sin, lewd, depraved, indecent, wicked"))
                   )
                   
                 ), #Sidebar end 
                 
                 mainPanel(
                   
                   plotOutput("mfd"),
                   
                   fluidRow(
                     tags$br()
                   ),
                   
                   fluidRow(
                   infoBox("Fox: % Moral Language", "13.22%", icon = icon("firefox"), fill = TRUE, color = "red"),
                   infoBox("ABC: % Moral Language", "9.86%", icon = icon("video"), fill = TRUE, color = "blue"),
                   infoBox("NBC: % Moral Language", "10.13%", icon = icon("feather-alt"), fill = TRUE, color = "blue"),
                   )
                   
                 ), 
                 
               )))
  
             # SENTIMENT
             
             # MORALITY
             
             # REFERENCES
             
  )) # UI end