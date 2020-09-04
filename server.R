
source("Functions.R")


# Allow upload of bigger files
# from http://stackoverflow.com/questions/18037737/how-to-change-maximum-upload-size-exceeded-restriction-in-shiny-and-save-user
# The first number is the number of MB
options(shiny.maxRequestSize=40*1024^2)

function(input, output, session) {


  extractColor <- eventReactive(input$Update,{
    
    r <- getColorOdonate(input$picture$datapath, n = input$n, cs = input$colorspace,
                  max = input$max,quantile = input$percentile )
    r <- r[r$colorspace %in% input$colorspace,]
  
    r <- r[which(r$hue > min(input$HUE)),]
    r <- r[which(r$hue < max(input$HUE)),]
    
    r <- r[which(r$sat > min(input$SAT)),]
    r <- r[which(r$sat < max(input$SAT)),]
    
    r <- r[which(r$value > min(input$BRI)),]
    r <- r[which(r$value < max(input$BRI)),]
  
    print(r)
  })
  
  output$plot1 <- renderPlot({
    
    scatterplot3d::scatterplot3d(extractColor()$sat*sin(extractColor()$hue),
                                 extractColor()$sat*cos(extractColor()$hue),
                                 extractColor()$value,
                                 xlab = "Saturation (x)",
                                 ylab = "Saturation (y)",
                                 zlab = "Brightness",
                                 color = extractColor()$hex, 
                                 pch = 16, type = "h",
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
         yaxt = "n",
         extractColor()$n/max(extractColor()$n), 
         col = extractColor()$hex,
         xlab = "Saturation", 
         ylim = c(0.0001,1),
         pch = 16,
         cex = 2, log = "x")
    
    
    
  })
  output$plot4 <- renderPlot({
    plot(extractColor()$value,
         extractColor()$n/max(extractColor()$n), 
         yaxt = "n",
         col = extractColor()$hex,
         xlab = "Brightness", 
         ylim = c(0.0001,1),
         pch = 16,
         cex = 2, log = "x")
    
    
    
  })
  
  
  extractColor2 <- eventReactive(input$Update2,{
    
    pathlist <-input$picture2$datapath
    
    
    withProgress(message = 'File:', value = 0, {
      
      n <- length(pathlist)
      
      img2 <-c()
      for(x in 1:n){
        
        incProgress(1/n, detail = paste(input$picture2$name[x]))
        img2[[x]] <- getColorOdonate(pathlist[x], 
                        n = input$n2,
                        max = input$max2,
                        cs = input$colorspace2,
                        quantile = input$percentile2)
        
        
      }
    })
    
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
         xlab = "Brightness",
         frame = F,
         ylab = "Saturation",
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
    plot(1,1, 
         col = extractColor2()[[1]]$hex, 
         xlim = c(0,1),
         ylim = c(0,1),
         xlab = "Brightness (Weighted means)",
         frame = F,
         ylab = "Saturation (Weighted means)",
         pch = 16, cex = 0)
    
    
    for(i in 1:length(input$picture2$name)){
      max<-max(extractColor2()[[i]]$n)
      points(Hmisc::wtd.mean(extractColor2()[[i]]$sat, weights = extractColor2()[[i]]$n),
             Hmisc::wtd.mean(extractColor2()[[i]]$value, weights = extractColor2()[[i]]$n),
             # col = sample(extractColor2()[[i]]$hex, 
             #              prob = (extractColor2()[[i]]$n/max)),
             pch = 16, cex = 2)
      text(Hmisc::wtd.mean(extractColor2()[[i]]$sat, extractColor2()[[i]]$n),
           Hmisc::wtd.mean(extractColor2()[[i]]$value, extractColor2()[[i]]$n),
           pos= 4,labels = names(extractColor2())[i])
      
      
    }
    
    
    # text(extractColor2()$resAV$AvSat,
    #      extractColor2()$resAV$AvLight, 
    #      labels = extractColor2()$resAV$id)
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    #####
    
    
    plot(BetaDev()$BWsat~BetaDev()$BWval, 
         col = "black", 
         xlab = "ß Brigthness",
         frame = F,
         ylab = "ß Saturation",
         pch = 16, cex = 2)
    abline(lm(BetaDev()$BWsat~BetaDev()$BWval))
    
    legend("toprigh", c(
      paste("colorspace", "=", input$colorspace2),
      paste("N","=", input$n2)))
    #####
  
    
  })
  
  

  BetaDev <- reactive({
    
    Wsat <- c()
    Wvalue  <- c()
    SDWsat <- c()
    SDWvalue <- c()
    for(i in 1:length(input$picture2$name)){
      
      Wsat[i] <-  Hmisc::wtd.mean(extractColor2()[[i]]$sat, weights = extractColor2()[[i]]$n)
      Wvalue[i] <- Hmisc::wtd.mean(extractColor2()[[i]]$value, weights = extractColor2()[[i]]$n)
      SDWsat[i] <-  (Hmisc::wtd.var(extractColor2()[[i]]$sat, extractColor2()[[i]]$n))
      SDWvalue[i] <- (Hmisc::wtd.var(extractColor2()[[i]]$value, extractColor2()[[i]]$n))
    }
    
    myFile <- data.frame(Wsat,Wvalue,SDWsat,SDWvalue, "name" = input$picture2$name)
    grid <- expand.grid("a" = unique(input$picture2$name)[-1],
                        "b" = unique(input$picture2$name)[-length(unique(input$picture2$name))])
    
    
    grid <- droplevels(grid)
    grid <- grid[!as.character(grid$a) == as.character(grid$b),]
    print(grid)
    BWsat <- c()
    BWval <- c()
    nam <- c()
    for(i in 1:dim(grid)[1]){
      BWsat[i] <- (myFile$Wsat[match(grid$a[i], myFile$name)]-myFile$Wsat[match(grid$b[i], myFile$name)])-
        (sqrt((myFile$SDWsat[match(grid$a[i], myFile$name)]+myFile$SDWsat[match(grid$b[i], myFile$name)])/2))
      BWval[i] <- (myFile$Wvalue[match(grid$a[i], myFile$name)]-myFile$Wvalue[match(grid$b[i], myFile$name)])-
        (sqrt((myFile$SDWvalue[match(grid$a[i], myFile$name)]+myFile$SDWvalue[match(grid$b[i], myFile$name)])/2))
      nam[i] <- paste0(as.character(grid$a[i]), "_",as.character(grid$b[i]))
      
    }
    
    myRes <- data.frame(BWsat, BWval, nam)
    print(myRes)
    myRes 
  })
  
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("results",".zip")
    },
    content = function(file) {
      #go to a temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      files <- NULL;
      
      #loop through the sheets
      for (i in 1:2){
        #write each sheet to a csv file, save the name
        fileName <- paste("results",i,".csv",sep = "")
        if(i == 1){
          write.csv(reshape2::melt(extractColor2()), fileName, row.names = FALSE)
          
        }else{
          write.csv(BetaDev(), fileName, row.names = FALSE)
          
        }
        
        files <- c(fileName,files)
      }
      #create the zip file
      zip(file,files)
      
      
    }
  )

}
               
