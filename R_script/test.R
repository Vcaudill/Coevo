source("R_script/make_dataframe.R")


file_info<- list.files("data/size", pattern="exp_K") #new files that i turned off the remove lines
place<-"data/size/"

split_df = make_dichotomy(file_info, place)
#adding a line for git
#second test for git
# a third test for good measure
file <- data.frame(split_df[1])
dichotomy<-data.frame(split_df[2])
