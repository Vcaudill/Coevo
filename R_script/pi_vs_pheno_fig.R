library(ggplot2)

sample_df = file[sample(nrow(file), 1000), ]
pdf(width=10,height=7,pointsize=12, paste0("figures/pi_by_voh_1d.pdf")[1])

ggplot()+
 #geom_point(data = sample_df, aes(y=abs(div_h), x = ind_h, color="H"), size = 1)+
  #geom_point(data = sample_df, aes(y=abs(div_p), x = ind_p, colour = 'P'), size = 1)+
  #geom_point(data = sample_df, aes(x=abs(dif_pheno+0.001), y = abs(dif_pi), colour = 'G'), size = 1)+
  
  geom_boxplot(data = sample_df, aes(y=abs(div_h), x = as.factor(v/h), color="H"), size = 1)+
  geom_boxplot(data = sample_df, aes(y=abs(div_p), x = as.factor(v/h), color="P"), size = 1)+
  
  
 # geom_boxplot(data = sample_df, aes(y=abs(div_h), x = as.factor(as.numeric(roundUp(ind_h))-as.numeric(roundUp(ind_p))), color="H"), size = 1)+
  #geom_boxplot(data = sample_df, aes(y=abs(div_p), x = as.factor(as.numeric(roundUp(ind_h))-as.numeric(roundUp(ind_p))), color="P"), size = 1)+
  #geom_boxplot(data = sample_df, aes(y=abs(dif_pheno), x = as.factor(as.numeric(roundUp(ind_p))-as.numeric(roundUp(ind_h))), color="G"), size = 1)+
  
  #scale_x_log10()+
  #scale_y_log10()+
    #xlim(1000, 3000)+
  scale_colour_manual(name="Lines",
                      breaks=c("H", "P", "G"), #, "PI", "PP"
                      #c=c("chocolate3","cyan4", "green"),
                      values=c("H"="mediumpurple","P"="pink", "G" = "seagreen"), #, "PI"="orchid", "PP"="lightgreen"
                      labels=c("Host", "Pathogen", "Dif"))+ #, "Dif btw PI", "Dif btw Phenotype"
  guides(colour = guide_legend(override.aes = list(size=4)))+
  theme_bw() + # setting up the theme
  theme(axis.text.x = element_text(size=10,colour="Black"),
        axis.text.y = element_text(size=18,colour="Black"),
        text = element_text(size=14),
        panel.grid.minor = element_blank(),
        legend.box.background = element_rect(),
        plot.title = element_text(size=12),
        plot.subtitle = element_text(size=12),
        #panel.grid = element_blank(),
        panel.spacing.x = unit(0.5,"line"))+
  xlab("Popsize") + ylab("Pi (Diversity)")

dev.off()

sample_2df = file_2d[sample(nrow(file_2d), 10000), ]
#file_2d$
ggplot()+
  geom_point(data = sample_2df, aes(y=abs(div_h), x = ind_h, color="H"), size = 1)+
  geom_point(data = sample_2df, aes(y=abs(div_p), x = ind_p, colour = 'P'), size = 1)+
  scale_x_log10()+
  #xlim(1000, 3000)+
  scale_colour_manual(name="Lines",
                      breaks=c("H", "P"), #, "PI", "PP"
                      #c=c("chocolate3","cyan4", "green"),
                      values=c("H"="mediumpurple","P"="pink"), #, "PI"="orchid", "PP"="lightgreen"
                      labels=c("Host", "Pathogen"))+ #, "Dif btw PI", "Dif btw Phenotype"
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
  ylab("Pi (Diversity)") + xlab("Popsize")




