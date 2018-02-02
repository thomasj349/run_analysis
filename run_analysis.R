#Download the files

if(!file.exists(".data/smartphone")){dir.create("./data/smartphone")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/smartphone.zip")
unzip("./data/smartphone.zip")

#read the data
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

#Make/Match Column Names

colnames(activity_labels) <- c("activity_id", "activity_type")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
colnames(x_test) <- features[,2]

y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE)
colnames(y_test) <- "activity_id"

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
colnames(subject_test) <- "subject_id"

test_data <- cbind(y_test, subject_test, x_test)

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
colnames(x_train) <- features[,2]

y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt",header = FALSE)
colnames(y_train) <- "activity_id"

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
colnames(subject_train) <- "subject_id"

train_data <- cbind(y_train, subject_train, x_train)


#You should create one R script called run_analysis.R that does the following.

#Merges the training ('train/X_train.txt': Training set) 
#and the test ('test/X_test.txt': Test set.) sets to create one data set.

combined_data <- rbind(test_data, train_data)

#Extracts only the measurements on the mean and standard deviation for each measurement.
colnames<-colnames(combined_data)
Extract_Mean_Std <-combined_data[,grepl("mean|std|subject|activity_id",colnames(combined_data))]
# Uses features to get required measurements

#Uses descriptive activity names to name the activities in the data set
Extract_Mean_Std$activity_id[Extract_Mean_Std$activity_id == "1"] <- "walking"
Extract_Mean_Std$activity_id[Extract_Mean_Std$activity_id == "2"] <- "walking_upstairs"
Extract_Mean_Std$activity_id[Extract_Mean_Std$activity_id == "3"] <- "walking_downstairs"
Extract_Mean_Std$activity_id[Extract_Mean_Std$activity_id == "4"] <- "sitting"
Extract_Mean_Std$activity_id[Extract_Mean_Std$activity_id == "5"] <- "standing"
Extract_Mean_Std$activity_id[Extract_Mean_Std$activity_id == "6"] <- "laying"

#Appropriately labels the data set with descriptive variable names.
names(Extract_Mean_Std)<- gsub("\\(", "", names(Extract_Mean_Std))
names(Extract_Mean_Std)<- gsub("\\)", "", names(Extract_Mean_Std))
Extract_Mean_Std <- arrange(Extract_Mean_Std, subject_id, activity_id)

#From the data set in step 4, creates a second, independent tidy data set with the average
#of each variable for each activity and each subject.
Final_data <- ddply(Extract_Mean_Std, c("activity_id", "subject_id"), numcolwise(mean))
View(Final_data)