

## Tool to extract the color space of an image
# Gabriel Muñoz 
# mar 2020 

library(tidyverse) ## I love ggplot and tidy data.... so this is a must for anything. 
library(magick) ## Hello magick!!! 
library(scales) ## I find rescale function so useful!  and i love show_col function :)
library(imager) ## i don't know how else to convert image to data frame at the moment. 

source("Functions.R")
## I'll use this plum flower image I took while back to extract colour. 
## using image_read function in magick I can read image as below. 
im <- image_read("sample1.jpg")

## now display image with 500px wide
im %>% image_resize("500")
## Reduce the colour used in image with image_quantize.  For example, let's say I want to reduce to 24 colours.
im %>%
  image_resize("500") %>%
  image_quantize(max=24)

get_colorPal(im)
params <- list(im=list(im), 
               n=12, ## number of colour you want 
               cs=colorspace_types()[-5]) ## gray fails so I've removed it...

my_colors <- pmap_df(params,get_colorPal)

## Let's see what got spitted out as results for different colourspace specifiction in image_quantize function.

## I want to view reduced colours by different colourspaces all at once! 
#########

png("ColorSpacesTest.png", width = 3000, height = 1000, pointsize = 30)
par(mfrow = c(1,2))
scatterplot3d::scatterplot3d(my_colors$hue,
                             my_colors$sat,
                             my_colors$n/max(my_colors$n),
                             box = F,cex.symbols = 2,
                             xlab = "hue",
                             ylab = "sat",
                             zlab = "freq", angle = 90,
                             pch = 16,
                             color = scales::alpha(my_colors$hex, 0.7))




plot(my_colors$sat,
     my_colors$hue,
     cex = log(my_colors$n/max(my_colors$n)*10000),
     xlab = "Saturation",
     ylab = "HUE",
     col = scales::alpha(my_colors$hex, 0.7),
     pch = 16)
points(my_colors$sat,
     my_colors$hue,
     cex = log(my_colors$n/max(my_colors$n)*10000),
     col = scales::alpha("grey", 0.4))
#########
dev.off()


figA <- magick::image_read("FullTest.png")
figB <- magick::image_read("ColorSpacesTest.png")

img <- c(figA, figB)
mosc <- image_append(image_scale(img, "1200"), stack = T)
image_write(mosc, path = "sample1", format = "png")

#####################

im <- image_read("sample2.png")

## now display image with 500px wide
im %>% image_resize("500")
## Reduce the colour used in image with image_quantize.  For example, let's say I want to reduce to 24 colours.
im %>%
  image_resize("500") %>%
  image_quantize(max=24)

get_colorPal(im)
params <- list(im=list(im), 
               n=12, ## number of colour you want 
               cs=colorspace_types()[-5]) ## gray fails so I've removed it...

my_colors <- pmap_df(params,get_colorPal)

## Let's see what got spitted out as results for different colourspace specifiction in image_quantize function.

## I want to view reduced colours by different colourspaces all at once! 
#########

png("ColorSpacesTest2.png", width = 3000, height = 1000, pointsize = 30)
par(mfrow = c(1,2))
scatterplot3d::scatterplot3d(my_colors$hue,
                             my_colors$sat,
                             my_colors$n/max(my_colors$n),
                             box = F,cex.symbols = 2,
                             xlab = "hue",
                             ylab = "sat",
                             zlab = "freq", angle = 90,
                             pch = 16,
                             color = scales::alpha(my_colors$hex, 0.7))




plot(my_colors$sat,
     my_colors$hue,
     cex = log(my_colors$n/max(my_colors$n)*10000),
     xlab = "Saturation",
     ylab = "HUE",
     col = scales::alpha(my_colors$hex, 0.7),
     pch = 16)
points(my_colors$sat,
       my_colors$hue,
       cex = log(my_colors$n/max(my_colors$n)*10000),
       col = scales::alpha("grey", 0.4))
#########
dev.off()


figA <- magick::image_read("sample2.png")
figB <- magick::image_read("ColorSpacesTest2.png")

img <- c(figA, figB)
mosc <- image_append(image_scale(img, "1200"), stack = T)
image_write(mosc, path = "test2.png", format = "png")

#####################

