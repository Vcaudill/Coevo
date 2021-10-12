# Beta exploration


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

var_by_var <- function(Newt_file_x, Snake_file_x, Newt_file_y, Snake_file_y, title, subt, x_label, y_label, section=FALSE, section_num = 0, logy=FALSE, subtract_x=FALSE, by_gen=FALSE, just_two=FALSE, colored=FALSE, color_label=NULL, highcol="darkseagreen"){
  
  if(section==FALSE){
  data_frame_newt_temp_x <- Newt_file_x
  data_frame_newt_temp_x <- data_frame_newt_temp_x[ , !(names(data_frame_newt_temp_x) %in% "variable")]
  
  data_frame_snake_temp_x <- Snake_file_x
  data_frame_snake_temp_x <- data_frame_snake_temp_x[ , !(names(data_frame_snake_temp_x) %in% "variable")]
  
  data_frame_newt_temp_y <- Newt_file_y
  data_frame_newt_temp_y <- data_frame_newt_temp_y[ , !(names(data_frame_newt_temp_y) %in% "variable")]
  
  data_frame_snake_temp_y <- Snake_file_y
  data_frame_snake_temp_y <- data_frame_snake_temp_y[ , !(names(data_frame_snake_temp_y) %in% "variable")]
  }
  if(section==TRUE){
    
    selcol = seq(1,ncol(Newt_file_x), section_num)
    
    data_frame_newt_temp_x <- Newt_file_x %>% select(all_of(selcol))
    data_frame_newt_temp_x <- data_frame_newt_temp_x[ , !(names(data_frame_newt_temp_x) %in% "variable")]
    
    data_frame_snake_temp_x <- Snake_file_x %>% select(all_of(selcol))
    data_frame_snake_temp_x <- data_frame_snake_temp_x[ , !(names(data_frame_snake_temp_x) %in% "variable")]
    
    data_frame_newt_temp_y <- Newt_file_y %>% select(all_of(selcol))
    data_frame_newt_temp_y <- data_frame_newt_temp_y[ , !(names(data_frame_newt_temp_y) %in% "variable")]
    
    data_frame_snake_temp_y <- Snake_file_y %>% select(all_of(selcol))
    data_frame_snake_temp_y <- data_frame_snake_temp_y[ , !(names(data_frame_snake_temp_y) %in% "variable")]
    
  }
  
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
  
  
  
  
  if(subtract_x==FALSE){
    combo <- rbind(data_frame_newt, data_frame_snake)
    combo_s <- combo[sample(nrow(combo), nrow(combo)), ]
    p <- ggplot(combo_s) +
      #xlim(0, 1000)+
      ggtitle(title, subtitle = subt) +
      xlab(x_label) + ylab(y_label)+
      geom_point(aes(x=as.numeric(value_x), y=as.numeric(value_y), color=type), alpha=0.1)+
      scale_color_manual(name = "Species", values = c("Newt" = "darkred", "Snake" = "steelblue"))+
      theme(plot.title = element_text(size=5)) +
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  }
  if(subtract_x==TRUE){
    subtract_val <- data_frame_snake_x$value_x - data_frame_newt_x$value_x
    total_sub_dataframe <- data.frame(subtract_val, data_frame_newt_y$value_y, data_frame_snake_y$value_y)
    total_sub_dataframe <- total_sub_dataframe[sample(nrow(total_sub_dataframe), nrow(total_sub_dataframe)), ]
    colnames(total_sub_dataframe) <- c("SnakeMisNewt_Pheno","Newts","Snakes")
    total_sub_dataframe$x.to <- total_sub_dataframe$SnakeMisNewt_Pheno
    total_sub_dataframe$y.toN <- total_sub_dataframe$Newts
    total_sub_dataframe$y.toS <- total_sub_dataframe$Snakes
    total_sub_dataframe$x.from <- c(total_sub_dataframe$SnakeMisNewt_Pheno[1], head(total_sub_dataframe$SnakeMisNewt_Pheno, -1))
    total_sub_dataframe$y.fromN <- c(total_sub_dataframe$Newts[1], head(total_sub_dataframe$Newts, -1))
    total_sub_dataframe$y.fromS <- c(total_sub_dataframe$Snakes[1], head(total_sub_dataframe$Snakes, -1))
    p <- ggplot(total_sub_dataframe) +
      #xlim(0, 1000)+
      ggtitle(title, subtitle = subt) +
      xlab(x_label) + ylab(y_label)+
      geom_point(aes(x=as.numeric(SnakeMisNewt_Pheno), y=as.numeric(Newts), color="Newts"), size=3)+
      geom_point(aes(x=as.numeric(SnakeMisNewt_Pheno), y=as.numeric(Snakes), color="Snakes"), size=3)+
      scale_colour_manual(name = "Species", values = c("Newts" = "darkred", "Snakes" = "steelblue"))+
      theme(plot.title = element_text(size=5)) +
      geom_segment( data=total_sub_dataframe, aes( x=x.from, y=y.fromN, xend=x.to, yend=y.toN ),lineend="round", linejoin='bevel', arrow=arrow(type="closed", length = unit(.15, "cm")),alpha=0.9, size=0.5)+
      geom_segment( data=total_sub_dataframe, aes( x=x.from, y=y.fromS, xend=x.to, yend=y.toS ),lineend="round", linejoin='bevel', arrow=arrow(type="closed", length = unit(.15, "cm")),alpha=0.9, size=0.5)+
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  }
  if(by_gen==TRUE){
    combo <- rbind(data_frame_newt, data_frame_snake)
    combo_s <- combo[sample(nrow(combo), nrow(combo)), ]
    p <- ggplot(combo_s) +
      #xlim(0, 1000)+
      ggtitle(title, subtitle = subt) +
      xlab(x_label) + ylab(y_label)+
      geom_point(aes(x=as.numeric(Number), y=as.numeric(value_y), color=type), alpha=0.1)+
      scale_color_manual(name = "Species", values = c("Newt" = "darkred", "Snake" = "steelblue"))+
      theme(plot.title = element_text(size=5)) +
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  }
  
  
  
  if(just_two==TRUE){
    just2 <- cbind(data_frame_newt_x, data_frame_snake_y)
    just2 <- just2[-4]
    p <- ggplot(just2) +
      #xlim(0, 1000)+
      ggtitle(title, subtitle = subt) +
      xlab(x_label) + ylab(y_label)+
      geom_point(aes(x=as.numeric(value_x), y=as.numeric(value_y)), color = "darkgreen", alpha=0.1)+
      theme(plot.title = element_text(size=5)) +
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  }
  
  
  if(colored==TRUE){
    color3 <- cbind(data_frame_newt_x, data_frame_snake_y, data_frame_newt_y)
    color3 <- color3[-c(1,3,4,6)]
    suppressWarnings(suppressMessages(suppressPackageStartupMessages({require(scales)})))
    amin <- 0.1
    lowcol.hex <- as.hexmode(round(col2rgb(highcol) * amin + 255 * (1 - amin)))
    lowcol <- paste0("#",   sep = "",
                     paste(format(lowcol.hex, width = 2), collapse = ""))
    p <- ggplot(color3) +
      #xlim(0, 1000)+
      ggtitle(title, subtitle = subt) +
      xlab(x_label) + ylab(y_label)+
      geom_point(aes(x=as.numeric(value_x), y=as.numeric(value_y), color = value_y.1))+
      theme(plot.title = element_text(size=5)) +
      scale_colour_gradient(high = highcol, low = lowcol) + 
      labs(colour = color_label) +
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  }
  if(logy==TRUE){
    p = p + scale_y_log10()
  }
  
  
  
  return(p)
  
  
}



# Files for No space results
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

# Files for No space gen_10000 results
files_gen_10000 <- list.files(path="~/Desktop/nospace/gen_10000", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)
file_gen_10000 <- read.table(files_gen_10000[51], header = TRUE)
beta_n_gen_10000 <- making_data_frames(files_gen_10000, all_of("beta_n"))
beta_s_gen_10000 <- making_data_frames(files_gen_10000, all_of("beta_s"))
Newt_mean_Pheno_gen_10000 <- making_data_frames(files_gen_10000, all_of("Newt_mean_Pheno"))
Snake_mean_Pheno_gen_10000 <- making_data_frames(files_gen_10000, all_of("Snake_mean_Pheno"))
Newt_sd_Pheno_gen_10000 <- making_data_frames(files_gen_10000, all_of("Newt_sd_Pheno"))
Snake_sd_Pheno_gen_10000 <- making_data_frames(files_gen_10000, all_of("Snake_sd_Pheno"))
mean_newts_eaten_gen_10000 <- making_data_frames(files_gen_10000, all_of("mean_newts_eaten"))
mean_snakes_eaten_gen_10000 <- making_data_frames(files_gen_10000, all_of("mean_snakes_eaten"))
newt_deaths_gen_10000 <- making_data_frames(files_gen_10000, all_of("newt_deaths"))
snake_deaths_gen_10000 <- making_data_frames(files_gen_10000, all_of("snake_deaths"))
Newt_age_gen_10000 <- making_data_frames(files_gen_10000, all_of("Newt_age"))
Snake_age_gen_10000 <- making_data_frames(files_gen_10000, all_of("Snake_age"))
Newt_pop_size_gen_10000 <- making_data_frames(files_gen_10000, all_of("Newt_pop_size"))
Snake_pop_size_gen_10000 <- making_data_frames(files_gen_10000, all_of("Snake_pop_size"))


# Files for space results
files_u5 <- list.files(path="~/Desktop/beta_u5", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)

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



#beta distribution
#space
hist(unlist(beta_s_s[ , 2:52]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="Space: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n_s[ , 2:52]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n_s[ , 2:52])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s_s[ , 2:52])), col = rgb(173,216,230, max = 255), lwd = 2)
legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))
#nospace
hist(unlist(beta_s[ , 2:52]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="NoSpace: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n[ , 2:52]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n[ , 2:52])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s[ , 2:52])), col = rgb(173,216,230, max = 255), lwd = 2)
legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))
#_gen_10000
hist(unlist(beta_s_gen_10000[ , 2:502]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="NoSpace gen 10,000: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n_gen_10000[ , 2:502]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n_gen_10000[ , 2:502])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s_gen_10000[ , 2:502])), col = rgb(173,216,230, max = 255), lwd = 2)
legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))

#Tornado plot
#no space
var_by_var( Newt_mean_Pheno, Snake_mean_Pheno, beta_n, beta_s, title="NoSpace: Differnece in mean phenotype by Betas", subt="sigma = 0.2, mu = 1.5625e-10", x_label="Dif in Pheno", y_label="Betas", subtract_x=TRUE)

var_by_var( making_data_frames(files[1], all_of("Newt_mean_Pheno")), making_data_frames(files[1], all_of("Snake_mean_Pheno")) , making_data_frames(files[1], all_of("beta_n")), making_data_frames(files[1], all_of("beta_s")), title="NoSpace: Differnece in mean phenotype by Betas", subt="sigma = 0.2, mu = 1.5625e-10", x_label="Dif in Pheno", y_label="Betas", subtract_x=TRUE)
# no space _gen_10000
var_by_var( Newt_mean_Pheno_gen_10000, Snake_mean_Pheno_gen_10000, beta_n_gen_10000, beta_s_gen_10000, title="NoSpace _gen_10000: Differnece in mean phenotype by Betas", subt="sigma = 0.2, mu = 1.5625e-10", x_label="Dif in Pheno", y_label="Betas", subtract_x=TRUE)

var_by_var( making_data_frames(files_gen_10000[1], all_of("Newt_mean_Pheno")), making_data_frames(files_gen_10000[1], all_of("Snake_mean_Pheno")) , making_data_frames(files_gen_10000[1], all_of("beta_n")), making_data_frames(files_gen_10000[1], all_of("beta_s")), title="NoSpace _gen_10000: Differnece in mean phenotype by Betas", subt="sigma = 0.2, mu = 1.5625e-10", section=TRUE, section_num =50, x_label="Dif in Pheno", y_label="Betas", subtract_x=TRUE)


title="GEN 1000 NoSpace: Differnece in mean phenotype by Betas"
subt="sigma = 0.2, mu = 1.5625e-10"
x_label="Dif in Pheno"
y_label="Betas"
dataframe <- data.frame(x=Snake_mean_Pheno$`1000`- Newt_mean_Pheno$`1000`, snake=beta_s$`1000`, newt=beta_n$`1000`)

p1 <- ggplot(dataframe) +
  #xlim(0, 1000)+
  ggtitle(title, subtitle = subt) +
  xlab(x_label) + ylab(y_label)+
  geom_point(aes(x=as.numeric(x), y=as.numeric(newt), color="Newts"))+
  geom_point(aes(x=as.numeric(x), y=as.numeric(snake), color="Snakes"))+
  scale_colour_manual(name = "Species", values = c("Newts" = "darkred", "Snakes" = "steelblue"))+
  theme(plot.title = element_text(size=5)) +
  theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))

title="GEN 100000 NoSpace: Differnece in mean phenotype by Betas"

dataframe <- data.frame(x=Snake_mean_Pheno_gen_10000$`10000`- Newt_mean_Pheno_gen_10000$`10000`, snake=beta_s_gen_10000$`10000`, newt=beta_n_gen_10000$`10000`)

p3 <- ggplot(dataframe) +
  #xlim(0, 1000)+
  ggtitle(title, subtitle = subt) +
  xlab(x_label) + ylab(y_label)+
  geom_point(aes(x=as.numeric(x), y=as.numeric(newt), color="Newts"))+
  geom_point(aes(x=as.numeric(x), y=as.numeric(snake), color="Snakes"))+
  scale_colour_manual(name = "Species", values = c("Newts" = "darkred", "Snakes" = "steelblue"))+
  theme(plot.title = element_text(size=5)) +
  theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))

title="GEN 1000 Space: Differnece in mean phenotype by Betas"

dataframe <- data.frame(x=Snake_mean_Pheno_s$`1000`- Newt_mean_Pheno_s$`1000`, snake=beta_s_s$`1000`, newt=beta_n_s$`1000`)

p2 <- ggplot(dataframe) +
  #xlim(0, 1000)+
  ggtitle(title, subtitle = subt) +
  xlab(x_label) + ylab(y_label)+
  geom_point(aes(x=as.numeric(x), y=as.numeric(newt), color="Newts"))+
  geom_point(aes(x=as.numeric(x), y=as.numeric(snake), color="Snakes"))+
  scale_colour_manual(name = "Species", values = c("Newts" = "darkred", "Snakes" = "steelblue"))+
  theme(plot.title = element_text(size=5)) +
  theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))

name_of_file= paste0("~/Desktop/figs/dif_in_pheno_by_beta_lastgen_1000", ".png")
png(filename =name_of_file)

print(grid.arrange(p1, p3, p2))
dev.off()

## beta at the beginning vs the end
name_of_file= paste0("~/Desktop/figs/beta_start_vs_end_3set", ".png")
png(filename =name_of_file)
par(mfrow=c(3,2))
#space
hist(unlist(beta_s_s[ , 2]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="Space, Gen1 : Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n_s[ , 2]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n_s[ , 2])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s_s[ , 2])), col = rgb(173,216,230, max = 255), lwd = 2)
#legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))
hist(unlist(beta_s_s[ , 52]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="Space, Gen1000: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n_s[ , 52]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n_s[ , 52])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s_s[ , 52])), col = rgb(173,216,230, max = 255), lwd = 2)
#legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))
#nospace
hist(unlist(beta_s[ , 2]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="NoSpace, Gen1: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n[ , 2]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n[ , 2])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s[ , 2])), col = rgb(173,216,230, max = 255), lwd = 2)
#legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))

hist(unlist(beta_s[ , 52]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="NoSpace Gen1000: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n[ , 52]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n[ , 52])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s[ , 52])), col = rgb(173,216,230, max = 255), lwd = 2)
#legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))



#_gen_10000
hist(unlist(beta_s_gen_10000[ , 2]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="NoSpace, Gen1: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n_gen_10000[ , 2]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n_gen_10000[ , 2])), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s_gen_10000[ , 2])), col = rgb(173,216,230, max = 255), lwd = 2)
#legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))

hist(unlist(beta_s_gen_10000[ , 502]), col=rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue"), main="NoSpace, Gen10,000: Beta Values", xlab="Beta", breaks=15) 
hist(unlist(beta_n_gen_10000[ , 502]), col=rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink"), add = TRUE, breaks=15) #ylim=c(0,2100)

abline(v = mean(unlist(beta_n_gen_10000[ , 502]), na.rm = TRUE), col = rgb(255,192,203, max = 255), lwd = 2)
abline(v = mean(unlist(beta_s_gen_10000[ , 502])), col = rgb(173,216,230, max = 255), lwd = 2)
#legend("topright", c("Newt", "Snake"), fill=c(rgb(255,192,203, max = 255), rgb(173,216,230, max = 255)))

dev.off()
## individual simulation files 
files <- list.files(path="~/Desktop/nospace/u5", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)
i=1
for(i in 1:length(files)){
  print(i)
  
  
  naame_of_file= paste0("~/Desktop/figs/nospace_beta_", i, ".png")
  png(filename =naame_of_file)
  vc_11 <- var_by_var( making_data_frames(files[i], all_of("Newt_mean_Pheno")), 
                       making_data_frames(files[i], all_of("Snake_mean_Pheno")), 
                       making_data_frames(files[i], all_of("beta_n")), 
                       making_data_frames(files[i], all_of("beta_s")), 
                       title="NoSpace: Differnece in mean phenotype by Betas", 
                       subt="sigma = 0.2, mu = 1.5625e-10", 
                       x_label="Dif in Pheno", y_label="Betas", subtract_x=TRUE)
  print(vc_11)
  dev.off()
}

files <- list.files(path="~/Desktop/nospace/gen_10000", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)
i=1
for(i in 1:length(files)){
  print(i)
  
  
  naame_of_file= paste0("~/Desktop/figs/nospace_10000_beta_", i, ".png")
  png(filename =naame_of_file)
  vc_11 <- var_by_var( making_data_frames(files[i], all_of("Newt_mean_Pheno")), 
                       making_data_frames(files[i], all_of("Snake_mean_Pheno")), 
                       making_data_frames(files[i], all_of("beta_n")), 
                       making_data_frames(files[i], all_of("beta_s")), 
                       title="NoSpace gen_10000: Differnece in mean phenotype by Betas", 
                       subt="sigma = 0.2, mu = 1.5625e-10", 
                       section=TRUE, section_num =50,
                       x_label="Dif in Pheno", y_label="Betas", subtract_x=TRUE)
  print(vc_11)
  dev.off()
}



