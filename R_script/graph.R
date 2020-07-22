library(ggplot2)
library(gridExtra)
library(gtable)

#file_info<- list.files("cut/tests", pattern="exp")
#file_info<- list.files("two_d_size/tests", pattern="exp") #new files that i turned off the remove lines
#file_info<- list.files("cut/tests", pattern=".txt")
test2d.txt
file_2d=read.table("test2d.txt",header = TRUE)


#file_info<- list.files("data/size/tests", pattern="exp") #new files that i turned off the remove lines
#place<-"data/size/tests/"

file_info<- list.files("raw_data/cut_data", pattern="exp_K") #new files that i turned off the remove lines
place<-"raw_data/cut_data/"

for (i in 1:length(file_info)){
  print(file_info[i])
  if(i == 1){
    #file=read.table(paste0("cut/tests/",file_info[1]),header = TRUE)
    file=read.table(paste0(place,file_info[1]),header = TRUE)
    file$trial <- strtoi(strsplit(unlist(strsplit(file_info[1], "trial_"))[2], ".txt"))
    file$id <- i
    file$name<-file_info[1]
  }
  #tempfile <- read.table(paste0("cut/tests/",file_info[i]), header = TRUE)
  tempfile <- read.table(paste0(place,file_info[i]), header = TRUE)
  tempfile$trial <- strtoi(strsplit(unlist(strsplit(file_info[i], "trial_"))[2], ".txt"))
  tempfile$id <- i
  tempfile$name<-file_info[i]
  file<-rbind(file,tempfile)
}
file$dif_pheno <- file$pheno_p - file$pheno_h
file$dif_pi <- file$div_p - file$div_h

x <- function (p) 2 * p * (1 - p/2)
y <- function (p) 2 * p * (1 - p)
p <- function (x) 1 - sqrt(1-x)
y(p(file$div_p))
p(x(0.3))
file$new_p<-p(y(file$div_p))
file$new_p_pi <- 2*p(x(file$div_p))*(1-p(x(file$div_p)))

pp <- runif(100)
plot(y(pp), y(p(x(pp))))

#file_2d_info<- list.files("data/two_d_size/tests", pattern="exp") #new files that i turned off the remove lines
#place_2d<-"data/two_d_size/tests/"

file_2d_info<- list.files("raw_data/cut_data", pattern="exp_2d") #new files that i turned off the remove lines
place_2d<-"raw_data/cut_data/"

for (i in 1:length(file_2d_info)){
  print(file_2d_info[i])
  if(i == 1){
    file_2d=read.table(paste0(place_2d,file_2d_info[1]),header = TRUE)
    file_2d$trial <- strtoi(strsplit(unlist(strsplit(file_2d_info[1], "trial_"))[2], ".txt"))
    file_2d$id <- i
    file_2d$name<-file_2d_info[1]
  }
  tempfile <- read.table(paste0(place_2d,file_2d_info[i]), header = TRUE)
  tempfile$trial <- strtoi(strsplit(unlist(strsplit(file_2d_info[i], "trial_"))[2], ".txt"))
  tempfile$id <- i
  tempfile$name<-file_2d_info[i]
  file_2d<-rbind(file_2d,tempfile)
}

#file_2d$dif_pheno <- file_2d$pheno_p - file_2d$pheno_h
file_2d$dif_pi <- file_2d$div_p - file_2d$div_h


file_info<- list.files("data/", pattern="Ttexp") #new files that i turned off the remove lines
place<-"data/"

for (i in 1:length(file_info)){
  print(file_info[i])
  if(i == 1){
    #file=read.table(paste0("cut/tests/",file_info[1]),header = TRUE)
    Tfile=read.table(paste0(place,file_info[1]),header = TRUE)
    Tfile$trial <- strtoi(strsplit(unlist(strsplit(file_info[1], "trial_"))[2], ".txt"))
    Tfile$id <- i
    Tfile$name<-file_info[1]
  }
  #tempfile <- read.table(paste0("cut/tests/",file_info[i]), header = TRUE)
  tempfile <- read.table(paste0(place,file_info[i]), header = TRUE)
  tempfile$trial <- strtoi(strsplit(unlist(strsplit(file_info[i], "trial_"))[2], ".txt"))
  tempfile$id <- i
  tempfile$name<-file_info[i]
  Tfile<-rbind(Tfile,tempfile)
}
Tfile$dif_pheno <- Tfile$pheno_p - Tfile$pheno_h
Tfile$dif_pi <- Tfile$div_p - Tfile$div_h


#data<-subset(file, ind_p >900 & ind_h >900 & trial ==1)


# test graphs now i have too much data
# ggplot(subset(file, ind_p >900 & ind_h >900), aes(gen,pheno_h))+
#   geom_point( color="blue")+
#   geom_point(data = subset(file, ind_p >900 & ind_h >900), aes(y = pheno_p), colour = 'red', size = 1)+
#   facet_wrap(subset(file, ind_p >900 & ind_h >900)$trial)
# 
# ggplot(subset(file, ind_p >900 & ind_h >900), aes(gen,div_h))+
#   geom_point( color="lightblue")+
#   geom_point(data = subset(file, ind_p >900 & ind_h >900), aes(y = div_p), colour = 'pink', size = 1)+
#   facet_wrap(subset(file, ind_p >900 & ind_h >900)$trial)
# 
# ggplot(subset(file, ind_p >900 & ind_h >900), aes(gen,pheno_h))+
#   geom_point( color="blue")+
#   geom_point(data = subset(file, ind_p >900 & ind_h >900), aes(y = pheno_p), colour = 'red', size = 1)+
#   facet_wrap(subset(file, ind_p >900 & ind_h >900)$trial)+
#   geom_point(data = subset(file, ind_p >900 & ind_h >900), aes(y = div_h), color="lightblue", size = 1)+
#   geom_point(data = subset(file, ind_p >900 & ind_h >900), aes(y = div_p), colour = 'pink', size = 1)+
#   facet_wrap(subset(file, ind_p >900 & ind_h >900)$trial)
# 
# 
# 
# ggplot(subset(file, id == 78), aes(gen,pheno_h))+
#   #geom_point( color="blue")+
#   #geom_point(data = subset(file, id == 78), aes(y = pheno_p), colour = 'red', size = 1)+
#   geom_point(data = subset(file, id == 78), aes(y = div_h), color="lightblue", size = 1)+
#   geom_point(data = subset(file, id == 78), aes(y = div_p), colour = 'pink', size = 1)+
#   geom_point(data = subset(file, id == 78), aes(y = dif_pheno), colour = 'green', size = 1)+
#   xlim(1000, 3000)
# 
# ggplot(subset(file, id == 54), aes(gen,pheno_h))+
#   #geom_point( color="blue")+
#   #geom_point(data = subset(file, id == 78), aes(y = pheno_p), colour = 'red', size = 1)+
#   geom_point(data = subset(file, id == 54), aes(y = div_h), color="lightblue", size = 1)+
#   geom_point(data = subset(file, id == 54), aes(y = div_p), colour = 'pink', size = 1)+
#   geom_point(data = subset(file, id == 54), aes(y = dif_pheno), colour = 'green', size = 1)+
#   xlim(1000, 1100)


# pdf(width=10,height=7,pointsize=12, paste0("figures/",subset(file, id == 87)$name, ".pdf")[1])
# 
# p1<-ggplot()+
#   #geom_point( color="blue")+
#   #geom_point(data = subset(file, id == 78), aes(y = pheno_p), colour = 'red', size = 1)+
#   geom_point(data = subset(file, id == 87), aes(x=gen, y = div_h, color="H"), size = 1)+
#   geom_point(data = subset(file, id == 87), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
#   geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
#   #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#   #xlim(1000, 3000)+
#   scale_colour_manual(name="Lines",
#                       breaks=c("H", "P", "PP"), #, "PI"
#                       #c=c("chocolate3","cyan4", "green"),
#                       values=c("H"="lightblue","P"="pink", "PP"="lightgreen"), #, "PI"="orchid"
#                       labels=c("Host", "Pathogen", "Dif btw Phenotype"))+ #, "Dif btw PI"
#   guides(colour = guide_legend(override.aes = list(size=4)))+
#   theme_bw() + # setting up the theme
#   theme(axis.text.x = element_text(size=18,colour="Black"),
#         axis.text.y = element_text(size=18,colour="Black"),
#         text = element_text(size=14),
#         panel.grid.minor = element_blank(),
#         legend.box.background = element_rect(),
#         plot.title = element_text(size=12),
#         plot.subtitle = element_text(size=22),
#         #panel.grid = element_blank(),
#         panel.spacing.x = unit(0.5,"line"))+
#   xlab("Generation") + ylab("Pi (Diversity)")+
#   labs(title = subset(file, id == 87)$name, subtitle = "My subtitle")
# dev.off()
# 
# pdf(width=10,height=7,pointsize=12, paste0("figures/",subset(file, id == 54)$name, ".pdf")[1])
# 
# p2<-ggplot()+
#   #geom_point( color="blue")+
#   #geom_point(data = subset(file, id == 78), aes(y = pheno_p), colour = 'red', size = 1)+
#   geom_point(data = subset(file, id == 54), aes(x=gen, y = div_h, color="H"), size = 1)+
#   geom_point(data = subset(file, id == 54), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
#   geom_point(data = subset(file, id == 54), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
#   #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#   #xlim(1000, 3000)+
#   scale_colour_manual(name="Lines",
#                       breaks=c("H", "P", "PP"), #, "PI"
#                       #c=c("chocolate3","cyan4", "green"),
#                       values=c("H"="lightblue","P"="pink", "PP"="lightgreen"), #, "PI"="orchid"
#                       labels=c("Host", "Pathogen", "Dif btw Phenotype"))+ #, "Dif btw PI"
#   guides(colour = guide_legend(override.aes = list(size=4)))+
#   theme_bw() + # setting up the theme
#   theme(axis.text.x = element_text(size=18,colour="Black"),
#         axis.text.y = element_text(size=18,colour="Black"),
#         text = element_text(size=14),
#         panel.grid.minor = element_blank(),
#         legend.box.background = element_rect(),
#         plot.title = element_text(size=12),
#         plot.subtitle = element_text(size=22),
#         #panel.grid = element_blank(),
#         panel.spacing.x = unit(0.5,"line"))+
#   xlab("Generation") + ylab("Pi (Diversity)")+
#   labs(title = subset(file, id == 54)$name, subtitle = "My subtitle")
# dev.off()
# 
# 
# grid.arrange(p1,p2)
# 
# pdf(width=10,height=7,pointsize=12, paste0("figures/",subset(file, id == 78)$name, ".pdf")[1])
# 
# ggplot()+
#   geom_point(data = subset(file, id == 78), aes(x=gen, y = div_h, color="H"), size = 1)+
#   geom_point(data = subset(file, id == 78), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
#   geom_point(data = subset(file, id == 78), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
#   #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#   #xlim(1000, 3000)+
#   scale_colour_manual(name="Lines",
#                       breaks=c("H", "P", "PP"), #, "PI"
#                       #c=c("chocolate3","cyan4", "green"),
#                       values=c("H"="lightblue","P"="pink", "PP"="lightgreen"), #, "PI"="orchid"
#                       labels=c("Host", "Pathogen", "Dif btw Phenotype"))+ #, "Dif btw PI"
#   guides(colour = guide_legend(override.aes = list(size=4)))+
#   theme_bw() + # setting up the theme
#   theme(axis.text.x = element_text(size=18,colour="Black"),
#         axis.text.y = element_text(size=18,colour="Black"),
#         text = element_text(size=14),
#         panel.grid.minor = element_blank(),
#         legend.box.background = element_rect(),
#         plot.title = element_text(size=12),
#         plot.subtitle = element_text(size=22),
#         #panel.grid = element_blank(),
#         panel.spacing.x = unit(0.5,"line"))+
#   xlab("Generation") + ylab("Pi (Diversity)")+
#   labs(title = subset(file, id == 78)$name, subtitle = "My subtitle")
# dev.off()
# 
# 
# for(i in 1:length(unique(file$id))){
#   #dev.off()
#   pdf(width=10,height=7,pointsize=12, paste0("figures/",subset(file, id == i)$name, ".pdf")[1])
#   
# print(ggplot()+
#     geom_point(data = subset(file, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
#     geom_point(data = subset(file, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
#     geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
#     #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#     #xlim(1000, 3000)+
#     scale_colour_manual(name="Lines",
#                         breaks=c("H", "P", "PP"), #, "PI"
#                         #c=c("chocolate3","cyan4", "green"),
#                         values=c("H"="lightblue","P"="pink", "PP"="lightgreen"), #, "PI"="orchid"
#                         labels=c("Host", "Pathogen", "Dif btw Phenotype"))+ #, "Dif btw PI"
#     guides(colour = guide_legend(override.aes = list(size=4)))+
#     theme_bw() + # setting up the theme
#     theme(axis.text.x = element_text(size=18,colour="Black"),
#           axis.text.y = element_text(size=18,colour="Black"),
#           text = element_text(size=14),
#           panel.grid.minor = element_blank(),
#           legend.box.background = element_rect(),
#           plot.title = element_text(size=12),
#           plot.subtitle = element_text(size=22),
#           #panel.grid = element_blank(),
#           panel.spacing.x = unit(0.5,"line"))+
#     xlab("Generation") + ylab("Pi (Diversity)")+
#     labs(title = subset(file, id == i)$name, subtitle = "My subtitle"))
#   dev.off()
#   
#   }
# 
# for(i in 1:length(unique(file$id))){
#   #dev.off()
#   pdf(width=10,height=7,pointsize=12, paste0("figures/zoom_",subset(file, id == i)$name, ".pdf")[1])
#   
#   print(ggplot()+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
#           #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#           xlim(1000, 2000)+
#           scale_colour_manual(name="Lines",
#                               breaks=c("H", "P", "PP"), #, "PI"
#                               #c=c("chocolate3","cyan4", "green"),
#                               values=c("H"="lightblue","P"="pink", "PP"="lightgreen"), #, "PI"="orchid"
#                               labels=c("Host", "Pathogen", "Dif btw Phenotype"))+ #, "Dif btw PI"
#           guides(colour = guide_legend(override.aes = list(size=4)))+
#           theme_bw() + # setting up the theme
#           theme(axis.text.x = element_text(size=18,colour="Black"),
#                 axis.text.y = element_text(size=18,colour="Black"),
#                 text = element_text(size=14),
#                 panel.grid.minor = element_blank(),
#                 legend.box.background = element_rect(),
#                 plot.title = element_text(size=12),
#                 plot.subtitle = element_text(size=22),
#                 #panel.grid = element_blank(),
#                 panel.spacing.x = unit(0.5,"line"))+
#           xlab("Generation") + ylab("Pi (Diversity)")+
#           labs(title = subset(file, id == i)$name, subtitle = "My subtitle"))
#   dev.off()
#   
# }
# 
# 
# for(i in 1:length(unique(file$id))){
#   #dev.off()
#   pdf(width=10,height=7,pointsize=12, paste0("figures/pheno_",subset(file, id == i)$name, ".pdf")[1])
#   
#   print(ggplot()+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_h, color="H"), size = 1)+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_p, colour = 'P'), size = 1)+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pi, colour = 'PP'), size = 1)+
#           #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#           #xlim(1000, 3000)+
#           scale_colour_manual(name="Lines",
#                               breaks=c("H", "P", "PP"), #, "PI"
#                               #c=c("chocolate3","cyan4", "green"),
#                               values=c("H"="navy","P"="firebrick", "PP"="seagreen"), #, "PI"="orchid"
#                               labels=c("Host", "Pathogen", "Dif in Pi"))+ #, "Dif btw PI"
#           guides(colour = guide_legend(override.aes = list(size=4)))+
#           theme_bw() + # setting up the theme
#           theme(axis.text.x = element_text(size=18,colour="Black"),
#                 axis.text.y = element_text(size=18,colour="Black"),
#                 text = element_text(size=14),
#                 panel.grid.minor = element_blank(),
#                 legend.box.background = element_rect(),
#                 plot.title = element_text(size=12),
#                 plot.subtitle = element_text(size=22),
#                 #panel.grid = element_blank(),
#                 panel.spacing.x = unit(0.5,"line"))+
#           xlab("Generation") + ylab("Phenotype")+
#           labs(title = subset(file, id == i)$name, subtitle = "My subtitle"))
#   dev.off()
#   
# }
# 
# for(i in 1:length(unique(file$id))){
#   #dev.off()
#   pdf(width=10,height=7,pointsize=12, paste0("figures/pheno_zoom_",subset(file, id == i)$name, ".pdf")[1])
#   
#   print(ggplot()+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_h, color="H"), size = 1)+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_p, colour = 'P'), size = 1)+
#           geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pi, colour = 'PP'), size = 1)+
#           #geom_point(data = subset(file, id == 87), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
#           xlim(1000, 2000)+
#           scale_colour_manual(name="Lines",
#                               breaks=c("H", "P", "PP"), #, "PI"
#                               #c=c("chocolate3","cyan4", "green"),
#                               values=c("H"="navy","P"="firebrick", "PP"="seagreen"), #, "PI"="orchid"
#                               labels=c("Host", "Pathogen", "Dif in Pi"))+ #, "Dif btw PI"
#           guides(colour = guide_legend(override.aes = list(size=4)))+
#           theme_bw() + # setting up the theme
#           theme(axis.text.x = element_text(size=18,colour="Black"),
#                 axis.text.y = element_text(size=18,colour="Black"),
#                 text = element_text(size=14),
#                 panel.grid.minor = element_blank(),
#                 legend.box.background = element_rect(),
#                 plot.title = element_text(size=12),
#                 plot.subtitle = element_text(size=22),
#                 #panel.grid = element_blank(),
#                 panel.spacing.x = unit(0.5,"line"))+
#           xlab("Generation") + ylab("Phenotype")+
#           labs(title = subset(file, id == i)$name, subtitle = "My subtitle"))
#   dev.off()
#   
# }
# 

## three plot on the same page
for(i in 1:length(unique(file$id))){
  #dev.off()
  png(width=1024, height=768, units = "px", pointsize = 12, bg = "white", res = 100, paste0("raw_data/figures/",subset(file, id == i)$name,"_id_", i ,".png")[1])
  #pdf(width=10,height=7,pointsize=12, paste0("figures/exp/",subset(file, id == i)$name, ".pdf")[1])
  
  p2<- ggplot()+
          geom_point(data = subset(file, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
          geom_point(data = subset(file, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
          #xlim(1000, 3000)+
          scale_colour_manual(name="Lines",
                              breaks=c("H", "P"), #, "PI", "PP"
                              #c=c("chocolate3","cyan4", "green"),
                              values=c("H"="mediumpurple","P"="pink"), #, "PI"="orchid", "PP"="lightgreen"
                              labels=c("Host", "Pathogen"))+ #, "Dif btw PI", "Dif btw Phenotype"
          guides(colour = guide_legend(override.aes = list(size=4)))+
          theme_bw() + # setting up the theme
          theme(axis.title.x=element_blank(),
                axis.text.x=element_blank(),
                axis.ticks.x=element_blank(),
                axis.text.y = element_text(size=18,colour="Black"),
                text = element_text(size=14),
                panel.grid.minor = element_blank(),
                legend.box.background = element_rect(),
                plot.title = element_text(size=12),
                plot.subtitle = element_text(size=22),
                #panel.grid = element_blank(),
                panel.spacing.x = unit(0.5,"line"))+
          xlab("Generation") + ylab("Pi (Diversity)")
  
  p1<- ggplot()+
    geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_h, color="H"), size = 1)+
    geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_p, colour = 'P'), size = 1)+
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"= "darkmagenta" ,"P"="firebrick"), #, "PI"="orchid" , "PP"="seagreen")
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", , "Dif in Pi"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Phenotype")+
    labs(title = subset(file, id == i)$name, subtitle = "My Plots")
  
  p3<-ggplot()+
    geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
    geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("PP", "PI"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("PP"="seagreen", "PI"="lightgreen"),
                        labels=c("Dif in Pheno", "Dif btw PI"))+ 
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.text.x = element_text(size=18,colour="Black"),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Difference")

g1 <- ggplotGrob(p1)  
g2 <- ggplotGrob(p2)  
g3 <- ggplotGrob(p3)  

g<- rbind(g1,g2,g3, size="first")  
print(grid.arrange(g))
  dev.off()
  
}

## three zoom plot on the same page
for(i in 1:length(unique(file$id))){
  #dev.off()
  png(width=1024, height=768, units = "px", pointsize = 12, bg = "white", res = 100, paste0("figures/exp/size_zoom_",subset(file, id == i)$name,"_id_", i , ".png")[1])
  #pdf(width=10,height=7,pointsize=12, paste0("figures/exp/",subset(file, id == i)$name, ".pdf")[1])
  
  p2<- ggplot()+
    geom_point(data = subset(file, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
    geom_point(data = subset(file, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
    xlim(1000, 2000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI", "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="mediumpurple","P"="pink"), #, "PI"="orchid", "PP"="lightgreen"
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", "Dif btw Phenotype"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Pi (Diversity)")
  
  p1<- ggplot()+
    geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_h, color="H"), size = 1)+
    geom_point(data = subset(file, id == i), aes(x=gen, y = pheno_p, colour = 'P'), size = 1)+
    xlim(1000, 2000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="darkmagenta","P"="firebrick"), #, "PI"="orchid" , "PP"="seagreen")
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", , "Dif in Pi"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Phenotype")+
    labs(title = subset(file, id == i)$name, subtitle = "My Plots")
  
  p3<-ggplot()+
    geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
    geom_point(data = subset(file, id == i), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
    xlim(1000, 2000)+
    scale_colour_manual(name="Lines",
                        breaks=c("PP", "PI"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("PP"="seagreen", "PI"="lightgreen"),
                        labels=c("Dif in Pheno", "Dif btw PI"))+ 
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.text.x = element_text(size=18,colour="Black"),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Difference")
  
  g1 <- ggplotGrob(p1)  
  g2 <- ggplotGrob(p2)  
  g3 <- ggplotGrob(p3)  
  
  g<- rbind(g1,g2,g3, size="first")  
  print(grid.arrange(g))
  dev.off()
  
}

## three plot on the same page 2d sim
for(i in 1:length(unique(file_2d$id))){
  #dev.off()
  png(width=1024, height=768, units = "px", pointsize = 12, bg = "white", res = 100, paste0("raw_data/figures/2d_",subset(file_2d, id == i)$name,"_id_", i , ".png")[1])
  #pdf(width=10,height=7,pointsize=12, paste0("figures/exp/",subset(file, id == i)$name, ".pdf")[1])
  
  p2<- ggplot()+
    
    geom_point(data = subset(file_2d, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
    geom_point(data = subset(file_2d, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
    
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI", "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="mediumpurple","P"="pink"), #, "PI"="orchid", "PP"="lightgreen"
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", "Dif btw Phenotype"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Pi (Diversity)")
  
  p1<- ggplot()+
    geom_line(data = subset(file_2d, id == i), aes(x=gen, y = pheno_hx, color="H"), size = 3)+
    geom_line(data = subset(file_2d, id == i), aes(x=gen, y = pheno_hy, color="Hy"), linetype="dotted", size = 1)+
    geom_line(data = subset(file_2d, id == i), aes(x=gen, y = pheno_px, colour = 'P'), size = 3)+
    geom_line(data = subset(file_2d, id == i), aes(x=gen, y = pheno_py, colour = 'Py'), linetype="dotted", size = 1)+
    #geom_line(linetype="dashed")+
    #geom_line(linetype = "dotdash")
    
    scale_colour_manual(name="Lines",
                        breaks=c("H", "Hy","P",  "Py"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="darkmagenta","Hy" = "darkmagenta", "P"="firebrick", "Py"="firebrick"), #, "PI"="orchid" , "PP"="seagreen")
                        labels=c("Host X","Host Y", "Pathogen X",  "Pathogen Y"))+ #, "Dif btw PI", , "Dif in Pi"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Phenotype")+
    labs(title = subset(file_2d, id == i)$name, subtitle = "My Plots")
  
  p3<-ggplot()+
    geom_point(data = subset(file_2d, id == i), aes(x=gen, y = eud, colour = 'E'), size = 1)+
    geom_point(data = subset(file_2d, id == i), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
    #xlim(1000, 3000)+
   
    scale_colour_manual(name="Lines",
                        breaks=c("E", "PI"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("E"="seagreen", "PI"="lightgreen"),
                        labels=c("Pheno E", "Dif btw PI"))+ 
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.text.x = element_text(size=18,colour="Black"),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Difference")
  
  g1 <- ggplotGrob(p1)  
  g2 <- ggplotGrob(p2)  
  g3 <- ggplotGrob(p3)  
  
  g<- rbind(g1,g2,g3, size="first")  
  grid.arrange(g)
  print(grid.arrange(g))
  dev.off()
  
}



#####Tfile


for(i in 1:length(unique(Tfile$id))){
  #dev.off()
  png(width=1024, height=768, units = "px", pointsize = 12, bg = "white", res = 100, paste0("figures/Tt_",subset(Tfile, id == i)$name,"_id_", i ,".png")[1])
  #pdf(width=10,height=7,pointsize=12, paste0("figures/exp/",subset(Tfile, id == i)$name, ".pdf")[1])
  
  p2<- ggplot()+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI", "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="mediumpurple","P"="pink"), #, "PI"="orchid", "PP"="lightgreen"
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", "Dif btw Phenotype"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Pi (Diversity)")
  
  p1<- ggplot()+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = pheno_h, color="H"), size = 1)+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = pheno_p, colour = 'P'), size = 1)+
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"= "darkmagenta" ,"P"="firebrick"), #, "PI"="orchid" , "PP"="seagreen")
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", , "Dif in Pi"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Phenotype")+
    labs(title = subset(Tfile, id == i)$name, subtitle = "My Plots")
  
  p3<-ggplot()+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = dif_pheno, colour = 'PP'), size = 1)+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("PP", "PI"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("PP"="seagreen", "PI"="lightgreen"),
                        labels=c("Dif in Pheno", "Dif btw PI"))+ 
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.text.x = element_text(size=18,colour="Black"),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Difference")
  
  g1 <- ggplotGrob(p1)  
  g2 <- ggplotGrob(p2)  
  g3 <- ggplotGrob(p3)  
  
  g<- rbind(g1,g2,g3, size="first")  
  print(grid.arrange(g))
  dev.off()
  
}


for(i in 1:length(unique(Tfile$id))){
  #dev.off()
  png(width=1024, height=768, units = "px", pointsize = 12, bg = "white", res = 100, paste0("figures/two_d_",subset(Tfile, id == i)$name,"_id_", i , ".png")[1])
  #pdf(width=10,height=7,pointsize=12, paste0("figures/exp/",subset(file, id == i)$name, ".pdf")[1])
  
  p2<- ggplot()+
    
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = div_h, color="H"), size = 1)+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = div_p, colour = 'P'), size = 1)+
    
    #xlim(1000, 3000)+
    scale_colour_manual(name="Lines",
                        breaks=c("H", "P"), #, "PI", "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="mediumpurple","P"="pink"), #, "PI"="orchid", "PP"="lightgreen"
                        labels=c("Host", "Pathogen"))+ #, "Dif btw PI", "Dif btw Phenotype"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Pi (Diversity)")
  
  p1<- ggplot()+
    geom_line(data = subset(Tfile, id == i), aes(x=gen, y = pheno_hx, color="H"), size = 3)+
    geom_line(data = subset(Tfile, id == i), aes(x=gen, y = pheno_hy, color="Hy"), linetype="dotted", size = 1)+
    geom_line(data = subset(Tfile, id == i), aes(x=gen, y = pheno_px, colour = 'P'), size = 3)+
    geom_line(data = subset(Tfile, id == i), aes(x=gen, y = pheno_py, colour = 'Py'), linetype="dotted", size = 1)+
    #geom_line(linetype="dashed")+
    #geom_line(linetype = "dotdash")
    
    scale_colour_manual(name="Lines",
                        breaks=c("H", "Hy","P",  "Py"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("H"="darkmagenta","Hy" = "darkmagenta", "P"="firebrick", "Py"="firebrick"), #, "PI"="orchid" , "PP"="seagreen")
                        labels=c("Host X","Host Y", "Pathogen X",  "Pathogen Y"))+ #, "Dif btw PI", , "Dif in Pi"
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Phenotype")+
    labs(title = subset(Tfile, id == i)$name, subtitle = "My Plots")
  
  p3<-ggplot()+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = eud, colour = 'E'), size = 1)+
    geom_point(data = subset(Tfile, id == i), aes(x=gen, y = dif_pi, colour = 'PI'), size = 1)+
    #xlim(1000, 3000)+
    
    scale_colour_manual(name="Lines",
                        breaks=c("E", "PI"), #, "PI",, "PP"
                        #c=c("chocolate3","cyan4", "green"),
                        values=c("E"="seagreen", "PI"="lightgreen"),
                        labels=c("Pheno E", "Dif btw PI"))+ 
    guides(colour = guide_legend(override.aes = list(size=4)))+
    theme_bw() + # setting up the theme
    theme(axis.text.x = element_text(size=18,colour="Black"),
          axis.text.y = element_text(size=18,colour="Black"),
          text = element_text(size=14),
          panel.grid.minor = element_blank(),
          legend.box.background = element_rect(),
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=22),
          #panel.grid = element_blank(),
          panel.spacing.x = unit(0.5,"line"))+
    xlab("Generation") + ylab("Difference")
  
  g1 <- ggplotGrob(p1)  
  g2 <- ggplotGrob(p2)  
  g3 <- ggplotGrob(p3)  
  
  g<- rbind(g1,g2,g3, size="first")  
  grid.arrange(g)
  print(grid.arrange(g))
  dev.off()
  
}


