source("R_script/make_dataframe.R")

file_info<- list.files("data/large_eff", pattern="les_K") #new files that i turned off the remove lines
file_inf_2d<- list.files("data/large_eff", pattern="les_2d") #new files that i turned off the remove lines

place<-"data/large_eff/"

split_df = make_dichotomy(file_info, place)

split_df_2d = make_2d_dichotomy(file_inf_2d, place)

file1 <- "large_eff_file"
file2 <- "large_eff_dichotomy"
save_file<- "data/csv_files/"
paste0(save_file, file1)
write.csv(data.frame(split_df[1]), paste0(save_file, file1, ".csv") )
write.csv(data.frame(split_df[2]), paste0(save_file, file2, ".csv"))

save_space(file1, file2, save_file)

file1_2d <- "large_small_eff_file"
file2_2d <- "large_small_eff_dichotomy"
save_file<- "data/csv_files/"

write.csv(data.frame(split_df_2d[1]), paste0(save_file, file1_2d, ".csv") )
write.csv(data.frame(split_df_2d[2]), paste0(save_file, file2_2d, ".csv"))

save_space(file1_2d, file2_2d, save_file)

zip::unzip(paste0(save_file_2d, file1, ".zip"), exdir = save_file)
zip::unzip(paste0(save_file_2d, file2, ".zip"), exdir = save_file)

file<-read.csv(paste0(save_file, file1, ".csv"))
dichotomy_large_eff<-read.csv(paste0(save_file, file2, ".csv"))
dichotomy_large_small_eff<-read.csv(paste0(save_file, file2_2d, ".csv"))



pdf(width=10,height=7,pointsize=12, paste0("figures/time_between_large_eff.pdf")[1])
ggplot(data = dichotomy_large_eff, aes(x=as.factor(h), y = d_mean, fill = as.factor(v) ))+
  #facet_wrap(~ sK)+
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
  xlab("Virus Population Size") + ylab("Time Between Intersection (Generation)")+
  labs(title = "Dichotomy Plot large_eff")
dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/close_by_virus_large_eff.pdf")[1])
ggplot(data = dichotomy_large_eff, aes(x=as.factor(h), y = close, fill = as.factor(v) ))+
  #facet_wrap(~ sK)+
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
  xlab("Virus Population Size") + ylab("Close Phenotypes Percentage")+
  labs(title = "Closeness Plot large_eff")
dev.off()


pdf(width=10,height=7,pointsize=12, paste0("figures/time_between_large_small_eff.pdf")[1])
ggplot(data = dichotomy_large_small_eff, aes(x=as.factor(h), y = d_mean, fill = as.factor(v) ))+
  #facet_wrap(~ sK)+
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
  xlab("Virus Population Size") + ylab("Time Between Intersection (Generation)")+
  labs(title = "Dichotomy Plot large_small_eff")
dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/close_by_virus_large_small_eff.pdf")[1])
ggplot(data = dichotomy_large_small_eff, aes(x=as.factor(h), y = close, fill = as.factor(v) ))+
  #facet_wrap(~ sK)+
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
  xlab("Virus Population Size") + ylab("Close Phenotypes Percentage")+
  labs(title = "Closeness Plot large_small_eff")
dev.off()

