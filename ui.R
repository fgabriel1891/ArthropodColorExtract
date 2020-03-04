library(shiny)
library(shinythemes)
library(tidyverse) ## I love ggplot and tidy data.... so this is a must for anything. 
library(magick) ## Hello magick!!! 
library(scales) ## I find rescale function so useful!  and i love show_col function :)
library(imager) ## i don't know how else to convert image to data frame at the moment. 
library(colorspace)

navbarPage("Odonate Color Extractor",
           tabPanel("Explore the color space",fluidPage(theme = shinytheme("flatly")),
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar(
                      headerPanel('Parameters'),
                      sidebarPanel(width = 4,
                                   fileInput("picture", label = "Upload the scan here", multiple = F),
                                   sliderInput("n", "Number of colors:",
                                               min = 1, max = 100,
                                               value = c(10)),
                                   sliderInput("max", "Maximum number of colors to quantize:",
                                               min = 1, max = 100,
                                               value = c(10)),
                                   sliderInput("percentile", "Percentile to remove:",
                                               min = 0, max = 1,
                                               value = c(0.5)),
                                   checkboxGroupInput(inputId = "colorspace",
                                                      label = 'ColorSpace:', choices = c("RGB" = "RGB"),
                                                      selected = c("RGB"="RGB"),inline=TRUE),
                                  shiny::actionButton(inputId = "Update", label = "Update parameters")
                      ),
                      mainPanel(

                        column(12,
                          plotOutput(outputId = "plot1", width = 1000, height = 500)),
                        column(4,
                          plotOutput(outputId = "plot2", width = 300, height = 300)),
                        column(4,
                          plotOutput(outputId = "plot3", width = 300, height = 300)),
                        column(4,
                               plotOutput(outputId = "plot4", width = 300, height = 300))
                        
                          
                          
                               
                        )
                        )
                    ),
           tabPanel("Explore differences in coloration",
                    pageWithSidebar(
                      headerPanel('Parameters'),
                      sidebarPanel(width = 4,
                                   fileInput("picture2", label = "Upload the standardized 
                                             scans here", multiple = T),
                                   sliderInput("n2", "Number of colors:",
                                               min = 1, max = 100,
                                               value = c(10)),
                                   sliderInput("max2", "Maximum number of colors to quantize:",
                                               min = 1, max = 100,
                                               value = c(10)),
                                   sliderInput("percentile2", "Percentile to remove:",
                                               min = 0, max = 1,
                                               value = c(0.5)),
                                   checkboxGroupInput(inputId = "colorspace2",
                                                      label = 'ColorSpace:', choices = c("RGB" = "RGB"),
                                                      selected = c("RGB"="RGB"),
                                                      inline=TRUE),
                                   shiny::actionButton(inputId = "Update2", label = "Update parameters"),
                                   # Button
                                   downloadButton("downloadData", "Download Results")
                      ),
                      mainPanel(
                        
                        column(12,
                               plotOutput(outputId = "plotFull",
                                          width = 1000, height = 500)),
                        
                        
                        column(12,
                               plotOutput(outputId = "plotAvR",
                                          width = 1000, height = 500))
                        
                      )
                    )),
           tabPanel("About",
                    p(), ".",style = "font-size:25px"),
                    
                    hr(), 
           
           tabPanel("Developer",
                    p(a("Gabriel Muñoz", href="", target="_blank"),style = "font-size:25px"),
                    p("e-mail: gabriel.munoz@concordia.ca",style = "font-size:20px"))
)

