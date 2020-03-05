
source("Functions.R")


# Allow upload of bigger files
# from http://stackoverflow.com/questions/18037737/how-to-change-maximum-upload-size-exceeded-restriction-in-shiny-and-save-user
# The first number is the number of MB
options(shiny.maxRequestSize=40*1024^2)

function(input, output, session) {


  extractColor <- eventReactive(input$Update,{
    print(input$n)
    r <- getColorOdonate(input$picture$datapath, n = input$n, cs = input$colorspace,
                  max = input$max,quantile = input$percentile )
    r <- r[r$colorspace %in% input$colorspace,]
  
    r <- r[which(r$hue > min(input$HUE)),]
    r <- r[which(r$hue < max(input$HUE)),]
    
    r <- r[which(r$sat > min(input$SAT)),]
    r <- r[which(r$sat < max(input$SAT)),]
    
    r <- r[which(r$value > min(input$BRI)),]
    r <- r[which(r$value < max(input$BRI)),]
  
    r
  })
  
  output$plot1 <- renderPlot({
    print(extractColor())
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
    
    im3 <- lapply(1:length(pathlist), function(x) im3[[x]][which(im3[[x]]$hue > min(input$HUE2)),])
    im3 <- lapply(1:length(pathlist), function(x) im3[[x]][which(im3[[x]]$hue < max(input$HUE2)),])
    
    im3 <- lapply(1:length(pathlist), function(x) im3[[x]][which(im3[[x]]$sat > min(input$SAT2)),])
    im3 <- lapply(1:length(pathlist), function(x) im3[[x]][which(im3[[x]]$sat < max(input$SAT2)),])
    
    im3 <- lapply(1:length(pathlist), function(x) im3[[x]][which(im3[[x]]$value > min(input$BRI2)),])
    im3 <- lapply(1:length(pathlist), function(x) im3[[x]][which(im3[[x]]$value < max(input$BRI2)),])
    
    
    
    names(im3) <- input$picture2$name
    
    
    im3
    
 
    # res <- data.frame("AvSat" = sapply(1:length(pathlist), 
    #                                    function(x) median(im3[[x]]$sat[which(im3[[x]]$sat > min(input$SAT2) 
    #                                                                    & im3[[x]]$sat < min(input$SAT2))])
    #                                    ),
    #                   "AvLight" = sapply(1:length(pathlist), 
    #                                      function(x) median(im3[[x]]$value[which(im3[[x]]$value > min(input$BRI2) 
    #                                                                      & im3[[x]]$value < min(input$BRI2))])),
    #                   "id" =  input$picture2$name)
    # print(res)
    # res2 <- data.frame("AvSat" = sapply(1:length(pathlist), 
    #                                     function(x) sd(im3[[x]]$sat[which(im3[[x]]$sat > min(input$SAT2) 
    #                                                                     & im3[[x]]$sat < min(input$SAT2))])),
    #                    "AvLight" = sapply(1:length(pathlist), 
    #                                       function(x) sd(im3[[x]]$value[which(im3[[x]]$sat > min(input$BRI2) 
    #                                                                   & im3[[x]]$sat < min(input$BRI2))])),
    #                    "id" =  input$picture2$name)
    # list("full" = im3,
    #      "resAV" = res,
    #      "resSD" = res2)
    
  })
  
  output$plotFull <- renderPlot({
    str(extractColor2())
    plot(extractColor2()[[1]]$sat, 
         extractColor2()[[1]]$value, 
         col = extractColor2()[[1]]$hex, 
         xlim = c(0,1),
         ylim = c(0,1),
         xlab = "Saturation",
         frame = F,
         ylab = "Brightness",
         pch = 16, 
         cex = log1p(extractColor2()[[1]]$n))
    for(i in 2:length(input$picture2$name)){
      
      points(extractColor2()[[i]]$sat,
             extractColor2()[[i]]$value,
             col = extractColor2()[[i]]$hex,
             pch = 16, 
             cex = log1p(extractColor2()[[1]]$n))
      
    }
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    
    
    
  })
  
  output$plotAvR <- renderPlot({
    
    
    ######
    par(mfrow=c(1,2))
    ######
    plot(mean(extractColor2()[[1]]$sat), 
         mean(extractColor2()[[1]]$value), 
         col = extractColor2()[[1]]$hex, 
         xlim = c(0,1),
         ylim = c(0,1),
         xlab = "Saturation",
         frame = F,
         ylab = "Brightness",
         pch = 16, cex = 2)
    for(i in 2:length(input$picture2$name)){
      
      points(mean(extractColor2()[[i]]$sat),
             mean(extractColor2()[[i]]$value),
             col = sample(extractColor2()[[i]]$hex, 
                          prob = (extractColor2()[[i]]$n/max(extractColor2()[[i]]$n))),
             pch = 16, cex = 2)
      
    }
    
    
    # text(extractColor2()$resAV$AvSat,
    #      extractColor2()$resAV$AvLight, 
    #      labels = extractColor2()$resAV$id)
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    #####
    
    
    plot(sd(extractColor2()[[1]]$sat), 
         sd(extractColor2()[[1]]$value), 
         col = extractColor2()[[1]]$hex, 
         xlim = c(0,1),
         ylim = c(0,1),
         xlab = "Saturation",
         frame = F,
         ylab = "Brightness",
         pch = 16, cex = 2)
    for(i in 2:length(input$picture2$name)){
      
      points(sd(extractColor2()[[i]]$sat),
             sd(extractColor2()[[i]]$value),
             col = sample(extractColor2()[[i]]$hex, 
                          prob = (extractColor2()[[i]]$n/max(extractColor2()[[i]]$n))),
             pch = 16, cex = 2)
      
    }
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    #####
    
    
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
               
