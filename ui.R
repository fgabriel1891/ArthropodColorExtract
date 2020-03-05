library(shiny)
library(shinythemes)
library(tidyverse) ## I love ggplot and tidy data.... so this is a must for anything. 
library(magick) ## Hello magick!!! 
library(scales) ## I find rescale function so useful!  and i love show_col function :)
library(imager) ## i don't know how else to convert image to data frame at the moment. 
library(colorspace)

navbarPage("ColorExtractR",
           tabPanel("1: Explore the color space",fluidPage(theme = shinytheme("yeti")),
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar(
                      headerPanel('Settings'),
                      sidebarPanel(width = 4,
                                   fileInput("picture", label = "Upload the scan here", multiple = F),
                                   p("Control this slider to set the number of initial distinct colors to separate"),
                                   sliderInput("n", "Number of colors:",
                                               min = 1, max = 100,
                                               value = c(10)),
                                   p("Control this slider to set the number of defined color groups to create from the sampled colors"),
                                   sliderInput("max", "Maximum number of colors to quantize:",
                                               min = 1, max = 100,
                                               value = c(10)),
                                   p("Control this slider to remove colors based on their percentile"),
                                   sliderInput("percentile", "Percentile to remove:",
                                               min = 0, max = 1,
                                               value = c(0.5)),
                                   p("Control this slider to select portions of the HUE space"),
                                   sliderInput("HUE", "Select hue range",
                                               min = 0, max = 360,
                                               value = c(0,360)),
                                   p("Control this slider to select portions of the Brigthness space"),
                                   sliderInput("BRI", "Select brightness range",
                                               min = 0, max = 1,
                                               value = c(0,0.5)),
                                   p("Control this slider to select portions of the saturation space"),
                                   sliderInput("SAT", "Select saturation range",
                                               min = 0, max = 1,
                                               value = c(0,0.5)),
                                   p("Select the color space to analize"),
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
           tabPanel("2: Batch explore coloration differences",
                    pageWithSidebar(
                      headerPanel('Settings'),
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
                                   sliderInput("HUE2", " Select HUE range:",
                                               min = 0, max = 360,
                                               value = c(0,360)),
                                   sliderInput("BRI2", "Select brightness range",
                                               min = 0, max = 1,
                                               value = c(0,1)),
                                   sliderInput("SAT2", "Select saturation range",
                                               min = 0, max = 1,
                                               value = c(0,1)),
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
                    pageWithSidebar(
                        tags$img(src = "imgfile.png"),
                      sidebarPanel(
                        h1("Welcome to ColorExtractR"))
                      ,
                      mainPanel(
                        
                        p(),
                        p(),p(),
                        p("This web application was created with the objective to extract and quantify the variation in  coloration schemes 
                          of digitized arthropod images. Nevertheless, it might very well be suitable for simple color analysis using any picture as input"),
                        p(),p(),p(),
                        p("Find the repository:"),p(),
                        p(a("https://github.com/fgabriel1891/ArthropodColorExtract",
                            href="", target="https://github.com/fgabriel1891/ArthropodColorExtract"))
                        
                        
                        
                      )
                    ),
                    
                  
                    p(), ".",style = "font-size:25px"),
           
           tabPanel("Developer",
                    p(a("Gabriel Muñoz", href="", target="https://github.com/fgabriel1891/"),style = "font-size:25px"),
                    p("e-mail: gabriel.munoz@concordia.ca",style = "font-size:20px"),
                    p("gitHub: /fgabriel1891",style = "font-size:20px"))
)

