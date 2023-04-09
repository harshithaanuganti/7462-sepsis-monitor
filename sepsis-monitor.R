#Task1 - SetUp
library(tidyverse)
library(data.table) ## For the fread function
library(lubridate)
library(tictoc)
library(googledrive) 
library(dplyr)
library(gt)
library(knitr)
library(ggplot2)

source("sepsis_monitor_functions.R")

#Task2 - Speed reading

n <- c(50,100,500)
#fread
tic.clearlog()
for(i in n){
  tic(i)
  f<-makeSepsisDataset(i,"fread")
  toc(log = TRUE, quiet = TRUE)
}
log.lst <- tic.log(format = FALSE)
tic.clearlog()
t_fread <- unlist(lapply(log.lst, function(i) as.numeric(i$toc - i$tic)))

#read_delim
tic.clearlog()
for(i in n){
  tic(i)
  f<-makeSepsisDataset(i,"read_delim")
  toc(log = TRUE, quiet = TRUE)
}
log.lst <- tic.log(format = FALSE)
tic.clearlog()
t_read_delim <- unlist(lapply(log.lst, function(i) as.numeric(i$toc - i$tic)))

#Task3 - Upload to Google Drive
library(googledrive)

df <- makeSepsisDataset()

# We have to write the file to disk first, then upload it
df %>% write_csv("sepsis_data_temp.csv")

# Uploading happens here
sepsis_file <- drive_put(media = "sepsis_data_temp.csv", 
                         path = "https://drive.google.com/drive/u/2/folders/10RZ9jk80E0ogD7xjfqD_fHL6JCtqi4ad",
                         name = "sepsis_data.csv")
  
# Set the file permissions so anyone can download this file.
sepsis_file %>% drive_share_anyone()
