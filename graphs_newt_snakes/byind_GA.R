#This will be the file that I use to animate the individual GA data
setwd("~/Desktop/Coevo/graphs_newt_snakes")
library(ggplot2)
library(viridis)
library(colorspace)
library(gridExtra)
library(tidyverse)
require(reshape2)
library(plyr)
library(gridGraphics)
library(grid)
library(gganimate)
library(gifski)
library(gapminder)

files <- list.files(path="~/Desktop/GA_lt/difV5000", pattern="GA6_litby", full.names=TRUE, recursive=FALSE)


number=1
myGA_file <- read.table(files[number], header = TRUE)

#max_newt_pheno = max(GA_file[GA_file$species=="N",]$phenotype)
#max_snake_pheno = max(GA_file[GA_file$species=="S",]$phenotype)




ggplot(graph_file, aes(loc_x, loc_y, color=species, group=species, alpha = phenotype/max(phenotype))) +
  #geom_point(data=graph_file[which(graph_file$species=="N"),],aes(alpha = phenotype/max_newt_pheno, shape=species),colour = "darkred")+ #colour = "darkred"
  #geom_point(data=graph_file[which(graph_file$species=="S"),],aes(alpha = phenotype/max_snake_pheno, shape=species), colour = "steelblue")+ #colour = "steelblue"
  geom_point()+
  scale_color_manual(values=c('darkred', 'steelblue'))+
  ggtitle(title, subtitle = subt) +
  #xlim(-1, 1000) +
  theme_bw()


for(i in seq(1, length(files), 1)){
  title<-"Phenotype bin Space By Generation"
  myGA_file <- read.table(files[i], header = TRUE)
  graph_file<-myGA_file
  frames<-length(unique(graph_file$gen))
  my_duration <- 50
  my_fps<-frames/my_duration
  snake_mu_rate <- unlist(str_split(unlist(str_split(files[i],"snake_mu_rate_"))[2], "_"))[1]
  newt_mu_rate <- unlist(str_split(unlist(str_split(files[i],"newt_mu_rate_"))[2], "_"))[1]
  snake_mu_effect_sd <- unlist(str_split(unlist(str_split(files[i],"snake_mu_effect_sd_"))[2], "_"))[1]
  newt_mu_effect_sd <- unlist(str_split(unlist(str_split(files[i],"newt_mu_effect_sd_"))[2], "_"))[1]
  subt <- paste0("Snake mu-rate & effect sd (", snake_mu_rate,", ", snake_mu_effect_sd, ") Newt mu-rate & effect sd (", newt_mu_rate, ", ", newt_mu_effect_sd, ")")  
  p <- ggplot(graph_file, aes(loc_x, loc_y, color=species, group=species, alpha = phenotype/max(phenotype))) +
    geom_point()+
    scale_color_manual(values=c('darkred', 'steelblue'))+
    ggtitle(title, subtitle = subt) +
    #xlim(-1, 1000) +
    theme_bw() +
    # gganimate specific bits:
    labs(title = 'Generation: {frame_time}', x = 'x loc', y = 'y loc') +
    transition_time(gen) +
    ease_aes('linear')
  animate(p, duration = my_duration, fps = my_fps, nframes=frames, width = 600, height = 400, renderer = gifski_renderer())
  anim_save(paste0("data/GA_animate_dif_", i,".gif"))
}


making_a_grid <- function(locx, locy) {
  value = 0

  if (locy<=7){
    value =+0
    if (locx<=7){
      value =+1
    }
    if (locx<=14 & locx>7 ){
      value =+2
    }
    if (locx<=21 & locx>14 ){
      value =+3
    }
    if (locx<=28 & locx>21 ){
      value =+4
    }
    if (locx>28 ){
      value =+5
    }
  }
  if (locy<=14 & locy>7 ){
    value =+1
    if (locx<=7){
      value =+1
    }
    if (locx<=14 & locx>7 ){
      value =+2
    }
    if (locx<=21 & locx>14 ){
      value =+3
    }
    if (locx<=28 & locx>21 ){
      value =+4
    }
    if (locx>28 ){
      value =+5
    }
  }
  if (locy<=21 & locy>14 ){
    value =+2
    if (locx<=7){
      value =+1
    }
    if (locx<=14 & locx>7 ){
      value =+2
    }
    if (locx<=21 & locx>14 ){
      value =+3
    }
    if (locx<=28 & locx>21 ){
      value =+4
    }
    if (locx<=35 & locx>28 ){
      value =+5
    }
  }
  if (locy<=28 & locy>21 ){
    value =+3
    if (locx<=7){
      value =+1
    }
    if (locx<=14 & locx>7 ){
      value =+2
    }
    if (locx<=21 & locx>14 ){
      value =+3
    }
    if (locx<=28 & locx>21 ){
      value =+4
    }
    if (locx>28 ){
      value =+5
    }
  }
  if (locy>28 ){
    value =+4
    if (locx<=7){
      value =+1
    }
    if (locx<=14 & locx>7 ){
      value =+2
    }
    if (locx<=21 & locx>14 ){
      value =+3
    }
    if (locx<=28 & locx>21 ){
      value =+4
    }
    if (locx>28 ){
      value =+5
    }
  }
  
  return(LETTERS[value])
}

myGA_file$label = "Z"
for (i in 6550555:nrow(myGA_file)){
  print(i)
  myGA_file$label[i]=making_a_grid(myGA_file$loc_x[i],myGA_file$loc_y[i])
}
making_a_grid

write.csv(myGA_file,"~/Desktop/with_grid_litbyind_snake_mu_rate_1.0e-08_newt_mu_rate_1.0e-08_snake_mu_effect_sd_0.05_newt_mu_effect_sd_0.05_sigma_0.5_FN_2949665473_ID_4086676209290_cost_100_interaction_rate_0.05_late_5000.csv", row.names = FALSE)



