
source("Functions.R")


function(input, output, session) {


  extractColor <- eventReactive(input$Update,{
    print(input$n)
    r <- getColorOdonate(input$picture$datapath, n = input$n, cs = input$colorspace,
                  max = input$max,quantile = input$percentile )
    r[r$colorspace %in% input$colorspace,]

  })
  
  output$plot1 <- renderPlot({
    
    scatterplot3d::scatterplot3d(extractColor()$value,
                                 (extractColor()$hue),
                                 extractColor()$sat,
                                 xlab = "Brightness",
                                 ylab = "HUE", 
                                 zlab = "Saturation",
                                 color = extractColor()$hex, 
                                 pch = 16,
                                 cex.symbols  = (1-(extractColor()$n/max(extractColor()$n)))*2,
                                 box = F)
         
    
    
    
  })
  
  
  output$plot2 <- renderPlot({
    plot( (extractColor()$hue), 
          extractColor()$n/max(extractColor()$n), 
         col = extractColor()$hex,
         xlab = "HUE", 
         ylab = "Frequency",
         pch = 16,
         cex = 2)
    
    
    
  })
  
  output$plot3 <- renderPlot({
    plot(extractColor()$sat, 
         extractColor()$n/max(extractColor()$n), 
         col = extractColor()$hex,
         xlab = "Saturation", 
         ylab = "Frequency",
         ylim = c(0.0001,1),
         pch = 16,
         cex = 2, log = "x")
    
    
    
  })
  output$plot4 <- renderPlot({
    plot(extractColor()$value,
         extractColor()$n/max(extractColor()$n), 
         col = extractColor()$hex,
         xlab = "Brightness", 
         ylab = "Frequency",
         ylim = c(0.0001,1),
         pch = 16,
         cex = 2, log = "x")
    
    
    
  })
  
  
  extractColor2 <- eventReactive(input$Update2,{
    print(input$picture2$datapath)
    pathlist <-input$picture2$datapath
    img2 <- lapply(1:length(pathlist), function(x) getColorOdonate(pathlist[x], 
                                                    n = input$n2,
                                                    max = input$max2,
                                                    cs = input$colorspace2,
                                                    quantile = input$percentile2))
    names(img2) <- input$picture2$name
    
    im3 <- lapply(1:length(pathlist), function(x) img2[[x]][img2[[x]]$colorspace == input$colorspace2,])
    names(im3) <- input$picture2$name
    res <- data.frame("AvSat" = sapply(1:length(pathlist), function(x) median(im3[[x]]$sat)),
                      "AvLight" = sapply(1:length(pathlist), function(x) median(im3[[x]]$value)),
                      "id" =  input$picture2$name)
    res2 <- data.frame("AvSat" = sapply(1:length(pathlist), function(x) sd(im3[[x]]$sat)),
                       "AvLight" = sapply(1:length(pathlist), function(x) sd(im3[[x]]$value)),
                       "id" =  input$picture2$name)
    list("full" = im3,
         "resAV" = res,
         "resSD" = res2)
    
  })
  
  output$plotFull <- renderPlot({
    str(extractColor2())
    plot(extractColor2()$full[[1]]$sat, 
         extractColor2()$full[[1]]$value, 
         col = extractColor2()$full[[1]]$hex, 
         xlim = c(0,1),
         ylim = c(0,1),
         xlab = "Saturation",
         frame = F,
         ylab = "Brightness",
         pch = 16, cex = 2)
    for(i in 2:length(input$picture2$name)){
      
      points(extractColor2()$full[[i]]$sat,
             extractColor2()$full[[i]]$value,
             col = extractColor2()$full[[i]]$hex,
             pch = 16, cex = 2)
      
    }
    legend("toprigh", c(
      paste("colorspace", "=", "HSV"),
      paste("N","=", "n")))
    
    
    
  })
  
  output$plotAvR <- renderPlot({
    
    
    ######
    par(mfrow=c(1,2))
    ######
    plot(extractColor2()$resAV$AvSat, 
         extractColor2()$resAV$AvLight, 
         xlim = c(0,1), 
         ylim = c(0,1), 
         frame = F,
         pch = 1, 
         xlab = "Saturation (median)",
         ylab = "Brightness (median)",
         cex = 0.5)
    text(extractColor2()$resAV$AvSat,
         extractColor2()$resAV$AvLight, 
         labels = extractColor2()$resAV$id)
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    #####
    plot(extractColor2()$resSD$AvSat,
         extractColor2()$resSD$AvLight, 
         xlim = c(0,1), 
         ylim = c(0,1), 
         frame = F,
         pch = 1, 
         xlab = "Saturation (sd)",
         ylab = "Brightness (sd)",
         cex = 0.5)
    text(extractColor2()$resSD$AvSat, 
         extractColor2()$resSD$AvLight, 
         labels = extractColor2()$resSD$id)
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    ########
    
    
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("fullResults", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(reshape2::melt(extractColor2()$full), file, row.names = FALSE)
    }
  )





}
               
