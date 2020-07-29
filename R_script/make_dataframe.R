
#list_of_data<- list.files("data/sigma", pattern="exp_K") #new files that i turned off the remove lines
#data_location<-"data/sigma/"

make_dichotomy <- function(list_of_data, data_location){
  library(ggplot2)
  library(gridExtra)
  library(gtable)
  library(plotrix)
  library(viridis)
  dichotomy<-data.frame(id= integer(length(list_of_data)), name = character(length(list_of_data)), v=integer(length(list_of_data)), h=integer(length(list_of_data)), sK=integer(length(list_of_data)), sC=integer(length(list_of_data)), d_mean = integer(length(list_of_data)), sd = integer(length(list_of_data)), se=integer(length(list_of_data)),stringsAsFactors=FALSE)
  
  for (i in 1:length(list_of_data)){
    print(list_of_data[i])
    if(i == 1){
      #file=read.table(paste0("cut/tests/",list_of_data[1]),header = TRUE)
      file=read.table(paste0(data_location,list_of_data[1]),header = TRUE)
      file$trial <- strtoi(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[2], ".txt"))
      file$id<- i
      file$name<-list_of_data[1]
      file$v<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[3])
      file$h<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[5])
      file$sK<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[8])
      file$sC<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[11])
      
      file$dif_pheno <- file$pheno_p - file$pheno_h
      
      dichotomy$id[1] <- i
      dichotomy$name[1]<-list_of_data[1]
      dichotomy$v[1]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[3])
      dichotomy$h[1]<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[5])
      dichotomy$sK[1]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[8])
      dichotomy$sC[1]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[11])
      file$dich = NA
      last_0 = 1
      close = 0
      
      for(j in 1:nrow(file)){
        
        if (abs(file$dif_pheno[j]) <= 2*file$sig_K[1]){
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
    #tempfile <- read.table(paste0("cut/tests/",list_of_data[i]), header = TRUE)
    tempfile <- read.table(paste0(data_location,list_of_data[i]), header = TRUE)
    tempfile$trial <- strtoi(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[2], ".txt"))
    tempfile$id <- i
    tempfile$name<-list_of_data[i]
    tempfile$v<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[3])
    tempfile$h<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[5])
    tempfile$sK<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[8])
    tempfile$sC<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[11])
    
    
    dichotomy$id[i] <- i
    dichotomy$name[i]<-list_of_data[i]
    dichotomy$v[i]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[3])
    dichotomy$h[i]<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[5])
    dichotomy$sK[i]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[8])
    dichotomy$sC[i]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[11])
    
    tempfile$dif_pheno <- tempfile$pheno_p - tempfile$pheno_h
    tempfile$dich = NA
    last_0 = 1
    close = 0
    for(j in 1:nrow(tempfile)){
      if (abs(tempfile$dif_pheno[j]) <= 2*tempfile$sig_K[1]){
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
  
  return(list(file, dichotomy))
}

#example
#list_of_data<- list.files("data/2d_size", pattern="exp") #new files that i turned off the remove lines
#data_location<-"data/2d_size/"

make_2d_dichotomy <- function(list_of_data, data_location){
  library(ggplot2)
  library(gridExtra)
  library(gtable)
  library(plotrix)
  library(viridis)
  dichotomy_2d<-data.frame(id= integer(length(list_of_data)), name = character(length(list_of_data)), v=integer(length(list_of_data)), h=integer(length(list_of_data)), sK=integer(length(list_of_data)), sC=integer(length(list_of_data)), d_mean = integer(length(list_of_data)), sd = integer(length(list_of_data)), se=integer(length(list_of_data)),stringsAsFactors=FALSE)
  
  for (i in 1:length(list_of_data)){
    print(list_of_data[i])
    if(i == 1){
      #file=read.table(paste0("cut/tests/",list_of_data[1]),header = TRUE)
      file_2d=read.table(paste0(data_location,list_of_data[1]),header = TRUE)
      file_2d$trial <- strtoi(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[2], ".txt"))
      file_2d$id<- i
      file_2d$name<-list_of_data[1]
      file_2d$v<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[4])
      file_2d$h<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[6])
      file_2d$sK<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[9])
      file_2d$sC<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[12])
      
      #file_2d$dif_pheno <- file_2d$pheno_p - file_2d$pheno_h
      
      dichotomy_2d$id[1] <- i
      dichotomy_2d$name[1]<-list_of_data[1]
      dichotomy_2d$v[1]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[4])
      dichotomy_2d$h[1]<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[6])
      dichotomy_2d$sK[1]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[9])
      dichotomy_2d$sC[1]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[1], "trial_"))[1], "_"))[12])
      
      file_2d$dich = NA
      last_0 = 1
      close = 0
      lessclose = 0
      for(j in 1:nrow(file_2d)){
        if (file_2d$eud[j] > -5 && file_2d$eud[j] < 5){
          file_2d$dich[j] = file_2d$gen[j] - last_0
          last_0 = file_2d$gen[j]
        }
        if (abs(file_2d$eud[j]) < 2*file_2d$sig_K[1]){
          close = 1 + close
        }
        if (abs(file_2d$eud[j]) < 4*file_2d$sig_K[1]){
          lessclose = 1 + lessclose
        }
        
      }
      dichotomy_2d$d_mean[1]=mean(file_2d$dich,na.rm=TRUE)
      dichotomy_2d$sd[1]<-sd(file_2d$dich,na.rm=TRUE)
      dichotomy_2d$se[1]<-std.error(file_2d$dich, na.rm=TRUE)
      dichotomy_2d$close[1]<-close/nrow(file_2d)
      dichotomy_2d$lessclose[1]<-lessclose/nrow(file_2d)
    }
    #tempfile <- read.table(paste0("cut/tests/",list_of_data[i]), header = TRUE)
    tempfile <- read.table(paste0(data_location,list_of_data[i]), header = TRUE)
    tempfile$trial <- strtoi(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[2], ".txt"))
    tempfile$id <- i
    tempfile$name<-list_of_data[i]
    tempfile$v<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[4])
    tempfile$h<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[6])
    tempfile$sK<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[9])
    tempfile$sC<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[12])
    
    
    dichotomy_2d$id[i] <- i
    dichotomy_2d$name[i]<-list_of_data[i]
    dichotomy_2d$v[i]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[4])
    dichotomy_2d$h[i]<- as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[6])
    dichotomy_2d$sK[i]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[9])
    dichotomy_2d$sC[i]<-as.numeric(unlist(strsplit(unlist(strsplit(list_of_data[i], "trial_"))[1], "_"))[12])
    
    #tempfile$dif_pheno <- tempfile$pheno_p - tempfile$pheno_h
    tempfile$dich = NA
    last_0 = 1
    close = 0 
    lessclose = 0 
    for(j in 1:nrow(tempfile)){
      if (tempfile$eud[j] > -5 && tempfile$eud[j] < 5){
        tempfile$dich[j] = tempfile$gen[j] - last_0
        last_0 = tempfile$gen[j]
      }
      if (abs(tempfile$eud[j]) < 2*tempfile$sig_K[1]){
        close = 1 + close
      }
      if (abs(tempfile$eud[j]) < 4*tempfile$sig_K[1]){
        lessclose = 1 + lessclose
      }
    }
    dichotomy_2d$d_mean[i]=mean(tempfile$dich, na.rm=TRUE)
    dichotomy_2d$sd[i]<-sd(tempfile$dich, na.rm=TRUE)
    dichotomy_2d$se[i]<-std.error(tempfile$dich, na.rm=TRUE)
    dichotomy_2d$close[i]<-close/nrow(tempfile)
    dichotomy_2d$lessclose[i]<-lessclose/nrow(tempfile)
    file_2d<-rbind(file_2d,tempfile)
  }
  
  # file_2d$dif_pheno <- file_2d$pheno_p - file_2d$pheno_h represented by the eud
  file_2d$dif_pi <- file_2d$div_p - file_2d$div_h
  
  
  dichotomy_2d<-dichotomy_2d[order(dichotomy_2d$h),] 
  dichotomy_2d$idh<-c(1:nrow(dichotomy_2d))
  return(list(file_2d, dichotomy_2d))
}

save_space <- function(file1, file2, data_location){
  library("zip")
  
  full_zip1<- paste0(data_location, file1,".zip")
  full_csv1<- paste0(data_location, file1,".csv")
  full_zip2<- paste0(data_location, file2,".zip")
  full_csv2<- paste0(data_location, file2,".csv")
  print(paste0("zip ", full_csv1))
  zip::zipr(full_zip1, full_csv1 )
  print(paste0("zip ", full_csv2))
  zip::zipr(full_zip2, full_csv2 )
  
  if (file.exists(full_csv1) && file.exists(full_zip1)) {
    #Delete file if it exists
    file.remove(full_csv1)}
  
  if (file.exists(full_csv2) && file.exists(full_zip2)) {
    #Delete file if it exists
    file.remove(full_csv2)}}

