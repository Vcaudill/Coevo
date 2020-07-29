library("data.table")
source("R_script/make_dataframe.R") # makes the dataframe(s)

file_info<- list.files("data/sigma", pattern="exp_K") #new files that i turned off the remove lines
place<-"data/sigma/"

split_df_sig = make_dichotomy(file_info, place)


file1 <- "sigma_file"
file2 <- "sigma_dichotomy"
save_file<- "data/csv_files/"

write.csv(data.frame(split_df_sig[1]), paste0(save_file, file1, ".csv") )
write.csv(data.frame(split_df_sig[2]), paste0(save_file, file2, ".csv"))

save_space(file1, file2, save_file)

zip::unzip(paste0(save_file, file1, ".zip"), exdir = save_file)
zip::unzip(paste0(save_file, file2, ".zip"), exdir = save_file)

#sigma_file <-read.csv(paste0(save_file, file1, ".csv"))
sigma_file<-fread(paste0(save_file, file1, ".csv"))
#sigma_dichotomy <-read.csv(paste0(save_file, file2, ".csv"))
sigma_dichotomy <-fread(paste0(save_file, file2, ".csv"))
save_space(file1, file2, save_file)

#DT[i, j, by], DT = Data.table
#Take DT, subset/reorder rows using i, then calculate j, grouped by by.
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html

steady_sig = sigma_file[sig_C == 0.4]
steady_di = sigma_dichotomy[sC == 0.4]


steady_sigK = sigma_file[sig_K == 1.]
steady_diK = sigma_dichotomy[sK == 1.]

