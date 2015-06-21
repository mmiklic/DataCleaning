library(dplyr)
library(reshape2)


downloadUnzip <- function() {
  fileURL <- paste('https://d396qusza40orc.cloudfront.net/',
                   'getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                   sep = '')
  if(!file.exists("./data_cleaning_course")) {
    dir.create("./data_cleaning_course")
    setwd("./data_cleaning_course")
  }
  download.file(fileURL,
                destfile = "./human_activity.zip",
                method = "curl")
  unzip("./human_activity.zip")
  user_msg <- paste("Finished downloading and unzipping.",
                    "Please run the extractWrite funct now.")
  print(user_msg)
}

extractWrite <- function() {
  ## 1.) Extracting and merging the test and training sets
  features <- read.table("./UCI HAR Dataset/features.txt")
  test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                             col.names = "Subject")
  x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                       col.names = features$V2)
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",
                       col.names = "ActivityIndex")
  train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                              col.names = "Subject")
  x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                        col.names = features$V2)
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",
                        col.names = "ActivityIndex")
  # Merge separate parts of train and test data (x values,
  # y labels and subject id)
  x_merged <- rbind(x_train, x_test)
  y_merged <- rbind(y_train, y_test)
  subject_merged <- rbind(train_subject, test_subject)

  ## 2.) Extracting mean and st dev measurements from the merged set
  mean.index <- which(as.logical(lapply(names(x_merged),
                                        function(x) grep(".mean.", x,
                                                         fixed = TRUE))))
  std.index <- which(as.logical(lapply(names(x_merged),
                                       function(x) grep(".std.", x,
                                                        fixed = TRUE))))
  index <- sort(c(mean.index, std.index))
  x_filtered <- x_merged[,index]
  # Add Subject and Activity to x_filtered
  filtered_df <- mutate(x_filtered,
                        Subject=subject_merged$Subject,
                        ActivityIndex=y_merged$ActivityIndex)

  ## 3.) Use descriptive Activity names
  act_index <- read.table("./UCI HAR Dataset/activity_labels.txt",
                          col.names = c("Index", "ActivityLabel"))
  labeled_set <- merge(filtered_df, act_index,
                       by.x = "ActivityIndex", by.y = "Index")
  # Remove Activity Index (now have labels)
  labeled_set$ActivityIndex <- NULL 

  ## 4.) labeled_set uses original variable names (changed to R format) to avoid manual
  ## renaming of 66 variables, which are actually already appropriately named

  ## 5.) Create a data set with an average of each variable for
  ## each activity and each subject
  melt_set <- melt(labeled_set, id=c("Subject", "ActivityLabel"))
  cast_set <- dcast(melt_set, Subject + ActivityLabel ~ variable,mean)

  # Write the final set to a txt file
  write.table(cast_set, "./tidy_set.txt", row.names = FALSE)
  print("Wrote tidy_set.txt")
}