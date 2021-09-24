
# This r script is to show what happens to a populations phenotype as the 
# population size of newts and snakes changes.

# My goal here is to graph the population size of newts by the population size 
# of snakes when the mean phenotype (resistance/toxin) as the color of the points


library(ggplot2)
library(viridis)
library(colorspace)
library(gridExtra)
library(tidyverse)
require(reshape2)
library(plyr)
library(grid)
library(gridGraphics)


making_data_frames <- function(files, spe_col) {
  i=1
  for (current_file in files){
    # print(current_file)
    
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

var_by_var <- function(Newt_file_x, Snake_file_x, Newt_file_y, Snake_file_y, title, subt, x_label, y_label, color_label=NULL, highcol="darkseagreen"){
  
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
  
  

    color3 <- cbind(data_frame_newt_x, data_frame_snake_y, data_frame_newt_y)
    color3 <- color3[-c(1,3,4,6)]
    color3$x.to <- color3$value_x
    color3$y.to <- color3$value_y
    color3$x.from <- c(color3$value_x[1], head(color3$value_x, -1))
    color3$y.from <- c(color3$value_y[1], head(color3$value_y, -1))
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
      geom_segment( data=color3, aes( x=x.from, y=y.from, xend=x.to, yend=y.to ),lineend="round", linejoin='bevel', arrow=arrow(type="closed", length = unit(.15, "cm")),alpha=0.9, size=0.5)+
      labs(colour = color_label) +
      theme_bw() +  theme(axis.text.x = element_text(angle = 45, hjust=1, size = 8))
  

  return(p)
}


files <- list.files(path="~/Desktop/nospace/u5", pattern="nu_*1.56", full.names=TRUE, recursive=FALSE)
i=1
for(i in 1:107){
print(i)
Newt_mean_Pheno_1 <- making_data_frames(files[i], all_of("Newt_mean_Pheno"))
Snake_mean_Pheno_1 <- making_data_frames(files[i], all_of("Snake_mean_Pheno"))
Newt_pop_size_1 <- making_data_frames(files[i], all_of("Newt_pop_size"))
Snake_pop_size_1 <- making_data_frames(files[i], all_of("Snake_pop_size"))

naame_of_file= paste0("~/Desktop/figs/nospace_", i, ".png")
png(filename =naame_of_file)
vc_11 <- var_by_var(Newt_pop_size_1, Newt_mean_Pheno_1, Newt_mean_Pheno_1, Snake_pop_size_1, title="Newt VS Snake Population Size Color=Phenotype", subt="sigma = 0.1, mu = 1.0e-10", y_label="Snake Popsize", x_label="Newt Popsize", color_label="Newt Phenotype" , highcol="darkred")
#dev.off()

#naame_of_file_2= paste0("~/Desktop/figs/snakes_", i, ".png")
#png(filename = naame_of_file_2)
vc_12 <- var_by_var(Newt_pop_size_1, Snake_mean_Pheno_1, Snake_mean_Pheno_1, Snake_pop_size_1, title="Newt VS Snake Population Size Color=Phenotype", subt="sigma = 0.1, mu = 1.0e-10", y_label="Snake Popsize", x_label="Newt Popsize", color_label="Snake Phenotype", highcol="steelblue")
print(grid.arrange(vc_11, vc_12))
dev.off()
}

