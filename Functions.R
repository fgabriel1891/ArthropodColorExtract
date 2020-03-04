## Function to get n number of colours out of your image. (optionally you can specify different colour space)

# https://www.r-bloggers.com/extracting-colours-from-your-images-with-image-quantization/

get_colorPal <- function(im, n=n, cs=cs){
  #print(cs) 
  tmp <-im %>% image_resize("100") %>% 
    image_quantize(max=n, colorspace=cs) %>%  ## reducing colours! different colorspace gives you different result
    magick2cimg() %>%  ## I'm converting, becauase I want to use as.data.frame function in imager package.
    RGBtoHSV() %>% ## i like sorting colour by hue rather than RGB (red green blue)
    as.data.frame(wide="c") %>%  #3 making it wide makes it easier to output hex colour
    mutate(hex=hsv(rescale(c.1, from=c(0,360)),c.2,c.3),
           hue = c.1,
           sat = c.2,
           value = c.3) %>%
    count(hex, hue, sat,value, sort=T) %>% 
    mutate(colorspace = cs)
  
  return(tmp %>% select(colorspace,hex,hue,sat,value,n)) ## I want data frame as a result.
  
}


#####
# Wrapper function to extract the color from arthropod figures 

getColorOdonate <- function(path, n, max,cs, quantile){
  ## I'll use this plum flower image I took while back to extract colour. 
  ## using image_read function in magick I can read image as below. 
  im <- image_read(path)
  
  ## now display image with 500px wide
  im %>% image_resize("500")
  ## Reduce the colour used in image with image_quantize.  For example, let's say I want to reduce to 24 colours.
  im %>%
    image_resize("500") %>%
    image_quantize(max=max)
  
  get_colorPal(im, n, cs)
  params <- list(im=list(im), 
                 n=n, ## number of colour you want 
                 cs=colorspace_types()[-5]) ## gray fails so I've removed it...
  
  my_colors <- pmap_df(params,get_colorPal)
  
  my_colors <- my_colors[(1-(my_colors$n/max(my_colors$n))) > quantile,]
}
