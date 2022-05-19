# This is the combo whale
# x- newt population size, y- snake population size color = snake - newt

library(ggplot2)
library(viridis)
library(colorspace)
library(gridExtra)
library(tidyverse)
require(reshape2)
library(plyr)
library(gridGraphics)
library(grid)

making_data_frames <- function(files, spe_col) {
  i=1
  for (current_file in files){
    #print(current_file)
    
    if(i ==1){
      file <- read.table(current_file, header = TRUE)
      
      file[[spe_col]][file[[spe_col]] == "NULL"] <- NA
      # might want to change to all_of(spe_col)
      file %>% 
        select(all_of(spe_col), gen) %>%
        #rownames_to_column() %>% 
        gather(variable, value, -gen) %>% 
        spread(gen, value) -> new_file
      
      new_file$variable[i] <- paste0(spe_col,"_trial_", i)
      i = i + 1
      next
    }
    file <- read.table(current_file, header = TRUE)
    
    file[[spe_col]][file[[spe_col]] == "NULL"] <- NA
    
    file %>% 
      select(all_of(spe_col), gen) %>%
      #rownames_to_column() %>% 
      gather(variable, value, -gen) %>% 
      spread(gen, value) -> temp_file
    
    temp_file$variable[1] <- paste0(spe_col,"_trial_", i)
    
    new_file<-rbind(new_file, temp_file)
    i = i + 1
  }
  return(new_file)
}

var_by_var <- function(Newt_file_x, Snake_file_x, Newt_file_y, Snake_file_y, title, subt, x_label, y_label, colored=FALSE, color_label=NULL, highcol="darkseagreen"){
  
  data_frame_newt_temp_x <- Newt_file_x
  data_frame_newt_temp_x <- data_frame_newt_temp_x[ , !(names(data_frame_newt_temp_x) %in% "variable")]
  
  data_frame_snake_temp_x <- Snake_file_x
  data_frame_snake_temp_x <- data_frame_snake_temp_x[ , !(names(data_frame_snake_temp_x) %in% "variable")]
  
  data_frame_newt_temp_y <- Newt_file_y
  data_frame_newt_temp_y <- data_frame_newt_temp_y[ , !(names(data_frame_newt_temp_y) %in% "variable")]
  
  data_frame_snake_temp_y <- Snake_file_y
  data_frame_snake_temp_y <- data_frame_snake_temp_y[ , !(names(data_frame_snake_temp_y) %in% "variable")]
  
  
  Number <- colnames(data_frame_newt_temp_x)
  data_frame_newt_x <- gather(data_frame_newt_temp_x, Number, value_x)
  data_frame_newt_x$type <- "Newt"
  data_frame_newt_y <- gather(data_frame_newt_temp_y, Number, value_y)
  data_frame_newt <- cbind(data_frame_newt_x, data_frame_newt_y)
  data_frame_newt <- data_frame_newt[-4]
  data_frame_snake_x <- gather(data_frame_snake_temp_x, Number, value_x)
  data_frame_snake_x$type <- "Snake"
  data_frame_snake_y <- gather(data_frame_snake_temp_y, Number, value_y)
  data_frame_snake <- cbind(data_frame_snake_x, data_frame_snake_y)
  data_frame_snake <- data_frame_snake[-4]
  dif <- data_frame_snake_x$value_x - data_frame_newt_y$value_y

  if(colored==TRUE){
    color3 <- cbind(data_frame_newt_x, data_frame_snake_y, dif)
    color3 <- color3[-c(1,3,4)]
    suppressWarnings(suppressMessages(suppressPackageStartupMessages({require(scales)})))
    amin <- 0.1
    highcol <- "steelblue"
    lowcol <- "darkred"

    p <- ggplot(color3) +
      #xlim(0, 1000)+
      ggtitle(title, subtitle = subt) +
      xlab(x_label) + ylab(y_label)+
      geom_point(aes(x=as.numeric(value_x), y=as.numeric(value_y), color = dif))+
      theme(plot.title = element_text(size=5)) +
      scale_colour_gradient2(high = "steelblue", mid = "beige", low = "darkred")+
      labs(colour = color_label) +
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  }
  
  
  
  return(p)
  
  
}


files <- list.files(path="~/Desktop/nospace/u5", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)
file <- read.table(files[51], header = TRUE)
beta_n <- making_data_frames(files, all_of("beta_n"))
beta_s <- making_data_frames(files, all_of("beta_s"))
Newt_mean_Pheno <- making_data_frames(files, all_of("Newt_mean_Pheno"))
Snake_mean_Pheno <- making_data_frames(files, all_of("Snake_mean_Pheno"))
Newt_sd_Pheno <- making_data_frames(files, all_of("Newt_sd_Pheno"))
Snake_sd_Pheno <- making_data_frames(files, all_of("Snake_sd_Pheno"))
mean_newts_eaten <- making_data_frames(files, all_of("mean_newts_eaten"))
mean_snakes_eaten <- making_data_frames(files, all_of("mean_snakes_eaten"))
newt_deaths <- making_data_frames(files, all_of("newt_deaths"))
snake_deaths <- making_data_frames(files, all_of("snake_deaths"))
Newt_age <- making_data_frames(files, all_of("Newt_age"))
Snake_age <- making_data_frames(files, all_of("Snake_age"))
Newt_pop_size <- making_data_frames(files, all_of("Newt_pop_size"))
Snake_pop_size <- making_data_frames(files, all_of("Snake_pop_size"))

# Files for space results
#files_u5 <- list.files(path="~/Desktop/beta_u5", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)
files_u5<- list.files(path="~/Desktop/cor_5000/cor_byUnit/text_files", pattern="GA5_lit_", full.names=TRUE, recursive=FALSE)
beta_n_s <- making_data_frames(files_u5, all_of("beta_n"))
beta_s_s <- making_data_frames(files_u5, all_of("beta_s"))
Newt_mean_Pheno_s <- making_data_frames(files_u5, all_of("Newt_mean_Pheno"))
Snake_mean_Pheno_s <- making_data_frames(files_u5, all_of("Snake_mean_Pheno"))
Newt_sd_Pheno_s <- making_data_frames(files_u5, all_of("Newt_sd_Pheno"))
Snake_sd_Pheno_s <- making_data_frames(files_u5, all_of("Snake_sd_Pheno"))
mean_newts_eaten_s <- making_data_frames(files_u5, all_of("mean_newts_eaten"))
mean_snakes_eaten_s <- making_data_frames(files_u5, all_of("mean_snakes_eaten"))
newt_deaths_s <- making_data_frames(files_u5, all_of("newt_deaths"))
snake_deaths_s <- making_data_frames(files_u5, all_of("snake_deaths"))
Newt_age_s <- making_data_frames(files_u5, all_of("Newt_age"))
Snake_age_s <- making_data_frames(files_u5, all_of("Snake_age"))
Newt_pop_size_s <- making_data_frames(files_u5, all_of("Newt_pop_size"))
Snake_pop_size_s <- making_data_frames(files_u5, all_of("Snake_pop_size"))


vc1 <- var_by_var(Newt_pop_size, Snake_mean_Pheno, Newt_mean_Pheno, Snake_pop_size, title="NoSpace: Newt VS Snake Population Size Color=Phenotype", subt="sigma = 0.1, mu = 1.0e-10", y_label="Snake Popsize", x_label="Newt Popsize", colored=TRUE, color_label="Snake-Newt Phenotype" , highcol="darkred") 

end = 3
vc2_s <- var_by_var(Newt_pop_size_s[,-(1:end)] , Snake_mean_Pheno_s[,-(1:end)], Newt_mean_Pheno_s[,-(1:end)], Snake_pop_size_s[,-(1:end)], title="Space: Newt VS Snake Population Size Color=Phenotype", subt="sigma = 0.1, mu = 1.0e-10", y_label="Snake Popsize", x_label="Newt Popsize", colored=TRUE, color_label="Snake-Newt Phenotype", highcol="steelblue") 

name_of_file= paste0("~/Desktop/figs/popsize_by_popsize_phenodifcolor", ".png")
png(filename =name_of_file)

print(grid.arrange(vc1, vc2_s))
dev.off()

title="LAST GEN NoSpace: Newt VS Snake Population Size Color=Phenotype"
subt="sigma = 0.1, mu = 1.0e-10"
y_label="Snake Popsize"
x_label="Newt Popsize"
color_label="Snake-Newt Phenotype"
dataframe <- data.frame(x=Newt_pop_size$`1000`, y=Snake_pop_size$`1000`, z=Snake_mean_Pheno$`1000`- Newt_mean_Pheno$`1000`)
last_vc1 <-ggplot(dataframe) +
  #xlim(0, 1000)+
  ggtitle(title, subtitle = subt) +
  xlab(x_label) + ylab(y_label)+
  geom_point(aes(x=as.numeric(x), y=as.numeric(y), color = z))+
  theme(plot.title = element_text(size=5)) +
  scale_colour_gradient2(high = "steelblue", mid = "beige", low = "darkred")+
  labs(colour = color_label) +
  theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))

dataframe <- data.frame(x=Newt_pop_size_s$`1000`, y=Snake_pop_size_s$`1000`, z=Snake_mean_Pheno_s$`1000`- Newt_mean_Pheno_s$`1000`)
title="LAST GEN Space: Newt VS Snake Population Size Color=Phenotype"
last_vc2_s <- ggplot(dataframe) +
  #xlim(0, 1000)+
  ggtitle(title, subtitle = subt) +
  xlab(x_label) + ylab(y_label)+
  geom_point(aes(x=as.numeric(x), y=as.numeric(y), color = z))+
  theme(plot.title = element_text(size=5)) +
  scale_colour_gradient2(high = "steelblue", mid = "beige", low = "darkred")+
  labs(colour = color_label) +
  theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  
last_name_of_file= paste0("~/Desktop/figs/popsize_by_popsize_phenodifcolor_lastgen_1000", ".png")
png(filename =last_name_of_file)

print(grid.arrange(last_vc1, last_vc2_s))
dev.off()
