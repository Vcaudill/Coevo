#!/usr/bin/env Rscript
# Plotting 4 plots on one png for the assembly line 
args = commandArgs(trailingOnly=TRUE)
# Packages
library(ggplot2)
library(gridExtra)
library(plyr)

#save_file="~/Desktop/pulled_info_test"
save_file=args[1]
folder_name=args[2]
png(paste0(folder_name, "/", save_file, ".png"), width=800,height=1000)

#path_to_file="~/Desktop/Coevo/newt_snake/data/space_test/pulled_info_test.txt"
#text_sub_title="file_redo_su_1.11e-11_nu_1.11e-11_sue_0.3_nue_0.3_17018532.txt"
#path_to_file="~/Desktop/test_case_space_dis.txt"
path_to_file=args[3]
text_sub_title=args[4]
space_data <- read.table(path_to_file, header = TRUE)

space_data$made_max= 0
end_gen = as.numeric(3000)
space_data$made_max<- ifelse(space_data$gen == 1 & space_data$type == "Newt", max(space_data[which(space_data$gen == 1 & space_data$type == "Newt"),]$ind_phy), 
                             ifelse(space_data$gen == 1 & space_data$type == "Snake", max(space_data[which(space_data$gen == 1 & space_data$type == "Snake"),]$ind_phy),
                                    ifelse(space_data$gen == end_gen & space_data$type == "Newt", max(space_data[which(space_data$gen == end_gen & space_data$type == "Newt"),]$ind_phy), 
                                           ifelse(space_data$gen == end_gen & space_data$type == "Snake", max(space_data[which(space_data$gen == end_gen & space_data$type == "Snake"),]$ind_phy), 0))))

space_data$my_alpha <- space_data$ind_phy/space_data$made_max

p1<-ggplot(space_data[which(space_data$gen == 1),], aes(x=loc_x, y=loc_y, color=type)) +
  ggtitle("Start Space: Generation 1", subtitle = text_sub_title) +
  xlab("Longitude") + ylab("Latitude")+
  #theme(plot.title = element_text(size=5)) +
  theme_bw() +  #theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))+
  scale_color_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+
  geom_point(aes(alpha=ind_phy))+
  scale_alpha_continuous(name = "Phenotype")

p2<-ggplot(space_data[which(space_data$gen == end_gen),], aes(x=loc_x, y=loc_y, color=type)) +
  ggtitle(paste0("End Space: Generation ", end_gen), subtitle = text_sub_title) +
  xlab("Longitude") + ylab("Latitude")+
  #theme(plot.title = element_text(size=5)) +
  scale_fill_manual(name = "Species", values = c('TRUE' = "darkred", 'FALSE' = "steelblue"), labels=c("Newts", "Snakes"))+
  scale_color_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+
  theme_bw() +  #theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))+
  geom_point(aes(alpha=ind_phy))+
  scale_alpha_continuous(name = "Phenotype")


p3<-ggplot(space_data[which(space_data$gen == 1),], aes(x=loc_x, y=loc_y, color=type)) +
  ggtitle("Start Space: Generation 1", subtitle = text_sub_title) +
  xlab("Longitude") + ylab("Latitude")+
  #theme(plot.title = element_text(size=5)) +
  theme_bw() +  #theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))+
  scale_color_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+
  geom_point(aes(alpha=my_alpha))+
  scale_alpha_continuous(name = "Percentage")

p4<-ggplot(space_data[which(space_data$gen == end_gen),], aes(x=loc_x, y=loc_y, color=type)) +
  ggtitle(paste0("End Space: Generation ", end_gen), subtitle = text_sub_title) +
  xlab("Longitude") + ylab("Latitude")+
  geom_point(aes(alpha=my_alpha, color=type)) +
  scale_alpha_continuous(name = "Percentage")+
  #theme(plot.title = element_text(size=5)) +
  scale_fill_manual(name = "Species", values = c('TRUE' = "darkred", 'FALSE' = "steelblue"), labels=c("Newts", "Snakes"))+
  scale_color_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+
  theme_bw()  #theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))+


mu_1gen <- ddply(space_data[which(space_data$gen == 1),], "type", summarise, grp.mean=mean(ind_phy))
mu_1000gen <- ddply(space_data[which(space_data$gen == 1),], "type", summarise, grp.mean=mean(ind_phy))


p5<-ggplot(space_data[which(space_data$gen == 1),], aes(x=ind_phy, color=type, fill=type), alpha=0.3) +
  ggtitle("Start Space: Generation 1", subtitle = text_sub_title) +
  xlab("Phenotype") + ylab("Count")+
  geom_histogram(position="identity", alpha=0.3)+
  geom_vline(data=mu_1gen, aes(xintercept=grp.mean, color=type),
             linetype="dashed")+
  scale_color_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+ 
  scale_fill_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+ 
  theme_bw()


p6<-ggplot(space_data[which(space_data$gen == end_gen),], aes(x=ind_phy, color=type, fill=type), alpha=0.3) +
  ggtitle(paste0("End Space: Generation ", end_gen), subtitle = text_sub_title) +
  xlab("Phenotype") + ylab("Count")+
  geom_histogram(position="identity", alpha=0.3)+
  geom_vline(data=mu_1000gen, aes(xintercept=grp.mean, color=type),
             linetype="dashed")+
  scale_color_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+ 
  scale_fill_manual(name = "Species", values = c('Newt' = "darkred", 'Snake' = "steelblue"), labels=c("Newts", "Snakes"))+ 
  theme_bw()
grid.arrange(p1, p2, p3, p4, p5, p6,
             ncol = 2, nrow = 3)

dev.off()
