## Load our libraries

library(dplyr)
library(tidyr)
library(tibble)

## Get the data

if(!dir.exists("./data")) dir.create("./data")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(fileURL, destfile = temp, method = "libcurl")
unzip(temp, exdir = "./data")
unlink(temp)

## Prepare for read

activitylabels <- "./data/UCI HAR Dataset/activity_labels.txt"
featurelabels <- "./data/UCI HAR Dataset/features.txt"
testdatadir <- "./data/UCI HAR Dataset/test/"
traindatadir <- "./data/UCI HAR Dataset/train/"

## For the activities, merge training and test sets plus add their names

labeled_actions <- rbind(read.table(paste(traindatadir, "y_train.txt", sep = ""), col.names = "activity_id"),
                        read.table(paste(testdatadir, "y_test.txt", sep = ""), col.names = "activity_id")) %>%
     left_join(read.table(activitylabels,
                          col.names = c("activity_id", "activity")), by = c("activity_id" = "activity_id"))

## For values, merge training and test sets, add activities and subjects

my_data <- rbind(read.table(paste(traindatadir, "X_train.txt", sep = "")),
                            read.table(paste(testdatadir, "X_test.txt", sep = ""))) %>%
     add_column(activity = as.character(labeled_actions[,2]), .before = 1) %>%
     add_column(subject = as.numeric(rbind(read.table(paste(traindatadir,"subject_train.txt", sep = "")),
                                           read.table(paste(testdatadir,"subject_test.txt", sep = "")))[,1]), .before = 1)
colnames(my_data) <- c("subject", "activity", as.character(read.table(featurelabels)[,2]))

## Clean up the environment

rm("labeled_actions", "activitylabels", "featurelabels", "testdatadir","traindatadir")

## keep only mean and std info

my_data <- my_data[,which(!duplicated(names(my_data)))] %>%
     select(subject, activity, contains("ean"), contains("std")) %>%
     select(-contains("angle("))

## Tidy up the data

my_data <- my_data %>% add_column(obs = 1:nrow(my_data), .before = 1) %>% 
     gather(measure, values, -(obs:activity)) %>% 
     separate(measure, into = c("measure", "type","axis"), fill = "left") %>% 
     spread(type, values)

my_data <- my_data[,-1]
my_data$axis[my_data$axis == ""] <- "Not Applicable"

## Summarize by average of each activity by subject

tidied_data <- summarise(group_by(my_data, subject, activity, measure, axis), 
                                  AvgMean = mean(mean), AvgMeanFreq = mean(meanFreq), AvgStd = mean(std))
