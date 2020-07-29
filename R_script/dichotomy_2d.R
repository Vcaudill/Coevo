
source("R_script/make_dataframe.R")

file_2d_info<- list.files("data/2d_size", pattern="exp") #new files that i turned off the remove lines
place<-"data/2d_size/"

split_2d_df = make_2d_dichotomy(file_2d_info, place)

file1 <- "size_file_2d"
file2 <- "size_dichotomy_2d"
save_file<- "data/csv_files/"
paste0(save_file, file1)
write.csv(data.frame(split_2d_df[1]), paste0(save_file, file1, ".csv") )
write.csv(data.frame(split_2d_df[2]), paste0(save_file, file2, ".csv"))

save_space(file1, file2, save_file)

zip::unzip(paste0(save_file, file1, ".zip"), exdir = save_file)
zip::unzip(paste0(save_file, file2, ".zip"), exdir = save_file)

file_2d<-read.csv(paste0(save_file, file1, ".csv"))
dichotomy_2d<-read.csv(paste0(save_file, file2, ".csv"))

save_space(file1, file2, save_file)

ggplot()+
  geom_point(data = dichotomy_2d, aes(x=id, y = d_mean, color = as.factor(paste0(dichotomy_2d$v,"x", dichotomy_2d$h))), size = 2)+
  geom_errorbar(data = dichotomy_2d, aes(x=idh, ymin=d_mean-sd, ymax=d_mean+sd,color = as.factor(v)), width=.5,
                position=position_dodge(.9))+
  #scale_x_log10()+
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
  xlab("Host Population Size") + ylab("Dichotomy")



pdf(width=10,height=7,pointsize=12, paste0("figures/di2_by_host",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy_2d, aes(x=as.factor(h), y = d_mean, fill = as.factor(v) ))+
  geom_boxplot()+
  scale_fill_brewer(name="Virus Population Size", palette="Dark2")+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=18,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=18),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        legend.title = element_text(size=16),
        legend.text = element_text(size = 14),
        plot.title = element_text(size=22),
        plot.subtitle = element_text(size=22),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Host Population Size") + ylab("Dichotomy")+
  labs(title = "Dichotomy Plot 2D")

dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/di2_by_virus",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy_2d, aes(x=as.factor(v), y = d_mean, fill = as.factor(h) ))+
  geom_boxplot()+
  scale_fill_viridis_d(name="Host Population Size",option = "C")+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=18,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=18),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        legend.title = element_text(size=16),
        legend.text = element_text(size = 14),
        plot.title = element_text(size=22),
        plot.subtitle = element_text(size=22),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Virus Population Size") + ylab("Dichotomy")+
  labs(title = "Dichotomy Plot 2D")
dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/close2_by_host",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy_2d, aes(x=as.factor(h), y = close, fill = as.factor(v) ))+
  geom_boxplot()+
  scale_fill_brewer(name="Virus Population Size", palette="Dark2")+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=18,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=18),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        legend.title = element_text(size=16),
        legend.text = element_text(size = 14),
        plot.title = element_text(size=22),
        plot.subtitle = element_text(size=22),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Host Population Size") + ylab("# of Generations")+
  labs(title = "Closeness Plot 2D")

dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/close2_by_virus",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy_2d, aes(x=as.factor(v), y = close, fill = as.factor(h) ))+
  geom_boxplot()+
  scale_fill_viridis_d(name="Host Population Size",option = "C")+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=18,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=18),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        legend.title = element_text(size=16),
        legend.text = element_text(size = 14),
        plot.title = element_text(size=22),
        plot.subtitle = element_text(size=22),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Virus Population Size") + ylab("# of Generations")+
  labs(title = "Closeness Plot 2D")
dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/lessclose2_by_host",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy_2d, aes(x=as.factor(h), y = lessclose, fill = as.factor(v) ))+
  geom_boxplot()+
  scale_fill_brewer(name="Virus Population Size", palette="Dark2")+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=18,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=18),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        legend.title = element_text(size=16),
        legend.text = element_text(size = 14),
        plot.title = element_text(size=22),
        plot.subtitle = element_text(size=22),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Host Population Size") + ylab("# of Generations")+
  labs(title = "Closeness Plot 2D")

dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/lessclose2_by_virus",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy_2d, aes(x=as.factor(v), y = lessclose, fill = as.factor(h) ))+
  geom_boxplot()+
  scale_fill_viridis_d(name="Host Population Size",option = "C")+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=18,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=18),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        legend.title = element_text(size=16),
        legend.text = element_text(size = 14),
        plot.title = element_text(size=22),
        plot.subtitle = element_text(size=22),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Virus Population Size") + ylab("# of Generations")+
  labs(title = "Closeness Plot 2D")
dev.off()

