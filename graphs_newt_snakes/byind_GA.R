#This will be the file that I use to animate the individual GA data

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

files <- list.files(path="~/Desktop/GA_lt/gen_5000/lit/text_files", pattern="GA2_litby", full.names=TRUE, recursive=FALSE)


number=1
myGA_file <- read.table(files[number], header = TRUE)

#max_newt_pheno = max(GA_file[GA_file$species=="N",]$phenotype)
#max_snake_pheno = max(GA_file[GA_file$species=="S",]$phenotype)

graph_file<-myGA_file
frames<-max(graph_file$gen)/100+1
my_duration <- 20
my_fps<-frames/my_duration
title<-"Phenotype bin Space By Generation"
subt<-"sim details"

ggplot(graph_file, aes(loc_x, loc_y, color=species, group=species, alpha = phenotype/max(phenotype))) +
  #geom_point(data=graph_file[which(graph_file$species=="N"),],aes(alpha = phenotype/max_newt_pheno, shape=species),colour = "darkred")+ #colour = "darkred"
  #geom_point(data=graph_file[which(graph_file$species=="S"),],aes(alpha = phenotype/max_snake_pheno, shape=species), colour = "steelblue")+ #colour = "steelblue"
  geom_point()+
  scale_color_manual(values=c('darkred', 'steelblue'))+
  ggtitle(title, subtitle = subt) +
  #xlim(-1, 1000) +
  theme_bw()


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
anim_save("data/gganimateGA1.gif")



