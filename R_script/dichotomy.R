library(ggplot2)
library(gridExtra)
library(gtable)
library(plotrix)
library(viridis) 

file_info<- list.files("data/size/tests", pattern="exp") #new files that i turned off the remove lines
place<-"data/size/tests/"
dichotomy<-data.frame(id= integer(length(file_info)), name = character(length(file_info)), v=integer(length(file_info)), h=integer(length(file_info)), sK=integer(length(file_info)), sC=integer(length(file_info)), d_mean = integer(length(file_info)), sd = integer(length(file_info)), se=integer(length(file_info)),stringsAsFactors=FALSE)

for (i in 1:length(file_info)){
  print(file_info[i])
  if(i == 1){
    #file=read.table(paste0("cut/tests/",file_info[1]),header = TRUE)
    file=read.table(paste0(place,file_info[1]),header = TRUE)
    file$trial <- strtoi(strsplit(unlist(strsplit(file_info[1], "trial_"))[2], ".txt"))
    file$id<- i
    file$name<-file_info[1]
    file$v<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[3])
    file$h<- as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[5])
    file$sK<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[8])
    file$sC<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[11])
    
    file$dif_pheno <- file$pheno_p - file$pheno_h
    
    dichotomy$id[1] <- i
    dichotomy$name[1]<-file_info[1]
    dichotomy$v[1]<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[1], "trial_"))[1], "_"))[3])
    dichotomy$h[1]<- as.numeric(unlist(strsplit(unlist(strsplit(file_info[1], "trial_"))[1], "_"))[5])
    dichotomy$sK[1]<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[1], "trial_"))[1], "_"))[8])
    dichotomy$sC[1]<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[1], "trial_"))[1], "_"))[11])
    file$dich = NA
    last_0 = 1
    close = 0
    
    for(j in 1:nrow(file)){
     
      if (abs(file$dif_pheno[j]) <= 2*file$sig_K[i]){
        close = 1 + close
        if (abs(file$dif_pheno[j]) == 0){
          file$dich[j] = file$gen[j] - last_0
          last_0 = file$gen[j]
        } 
      }
    }
    dichotomy$d_mean[1]=mean(file$dich,na.rm=TRUE)
    dichotomy$sd[1]<-sd(file$dich,na.rm=TRUE)
    dichotomy$se[1]<-std.error(file$dich, na.rm=TRUE)
    dichotomy$close[1]<-close/nrow(file)
  }
  #tempfile <- read.table(paste0("cut/tests/",file_info[i]), header = TRUE)
  tempfile <- read.table(paste0(place,file_info[i]), header = TRUE)
  tempfile$trial <- strtoi(strsplit(unlist(strsplit(file_info[i], "trial_"))[2], ".txt"))
  tempfile$id <- i
  tempfile$name<-file_info[i]
  tempfile$v<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[3])
  tempfile$h<- as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[5])
  tempfile$sK<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[8])
  tempfile$sC<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[11])
  
  
  dichotomy$id[i] <- i
  dichotomy$name[i]<-file_info[i]
  dichotomy$v[i]<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[3])
  dichotomy$h[i]<- as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[5])
  dichotomy$sK[i]<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[8])
  dichotomy$sC[i]<-as.numeric(unlist(strsplit(unlist(strsplit(file_info[i], "trial_"))[1], "_"))[11])
  
  tempfile$dif_pheno <- tempfile$pheno_p - tempfile$pheno_h
  tempfile$dich = NA
  last_0 = 1
  close = 0
  for(j in 1:nrow(tempfile)){
    if (abs(tempfile$dif_pheno[j]) <= 2*tempfile$sig_K[i]){
      close = 1 + close
      if (abs(tempfile$dif_pheno[j]) == 0){
        tempfile$dich[j] = tempfile$gen[j] - last_0
        last_0 = tempfile$gen[j]
      } 
    }
  }
  dichotomy$d_mean[i]=mean(tempfile$dich, na.rm=TRUE)
  dichotomy$sd[i]<-sd(tempfile$dich, na.rm=TRUE)
  dichotomy$se[i]<-std.error(tempfile$dich, na.rm=TRUE)
  dichotomy$close[i]<-close/nrow(tempfile)
  file<-rbind(file,tempfile)
}

file$dif_pheno <- file$pheno_p - file$pheno_h

dichotomy<-dichotomy[order(dichotomy$h),] 
dichotomy$idh<-c(1:nrow(dichotomy))
ggplot()+
  geom_point(data = dichotomy, aes(x=idh, y = d_mean, color = as.factor(v)), size = 2)+
  geom_errorbar(data = dichotomy, aes(x=idh, ymin=d_mean-sd, ymax=d_mean+sd,color = as.factor(v)), width=.5,
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
  
  
pdf(width=10,height=7,pointsize=12, paste0("figures/di_by_host",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy, aes(x=as.factor(h), y = d_mean, fill = as.factor(v) ))+
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
  labs(title = "Dichotomy Plot")

dev.off()

pdf(width=10,height=7,pointsize=12, paste0("figures/di_by_virus",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy, aes(x=as.factor(v), y = d_mean, fill = as.factor(h) ))+
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
  labs(title = "Dichotomy Plot")

dev.off()


#dichotomy$close

pdf(width=10,height=7,pointsize=12, paste0("figures/close_by_host",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy, aes(x=as.factor(h), y = close, fill = as.factor(v) ))+
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
  labs(title = "Closeness Plot")

dev.off()


pdf(width=10,height=7,pointsize=12, paste0("figures/close_by_virus",subset(file, id == i)$name, ".pdf")[1])

ggplot(data = dichotomy, aes(x=as.factor(v), y = close, fill = as.factor(h) ))+
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
  labs(title = "Closeness Plot")
dev.off()
