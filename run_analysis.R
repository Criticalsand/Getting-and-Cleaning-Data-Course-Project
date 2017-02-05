# This is the R script for Getting and Cleaning Data couse project
# The purpopse of this project is to demonstrate your ability to collect, work with,
# and clean a data set.
# The goal is to prepare tidy data that can be used for later analysis.

# 1. Merges the training and test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activity in the data set.
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.


# Download and unzip dataset

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "Course Prject Dataset.zip"

if (!file.exists("UCI HAR Dataset")) {
    download.file(fileURL, fileName, method = "curl")
    unzip(fileName)
}

setwd("/Users/HY/Dropbox/Data Science/Getting and Cleanning Data/Course Project/UCI HAR Dataset")

# Install and load packages
package <- c("dplyr", "reshape2")
install.packages(package)
lapply(package, library, character.only = TRUE)

## Step 1: Merges the training and test sets to create one data set.
fileXtest <- "./test/X_test.txt"
fileXtrain <- "./train/X_train.txt"
Xtest <- read.table(fileXtest)
Xtrain <- read.table(fileXtrain)
XMerge <- rbind(Xtest, Xtrain)

fileYtest <- "./test/y_test.txt"
fileYtrain <- "./train/y_train.txt"
Ytest <- read.table(fileYtest)
Ytrain <- read.table(fileYtrain)
YMerge <- rbind(Ytest, Ytrain)

fileSubjectTest <- "./test/subject_test.txt"
fileSubjectTrain <- "./train/subject_train.txt"
SubjectTest <- read.table(fileSubjectTest)
SubjectTrain <- read.table(fileSubjectTrain)
SubjectMerge <- rbind(SubjectTest, SubjectTrain)

DataMerged <- cbind(SubjectMerge, YMerge, XMerge)


## Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
fileFeatures <- "./features.txt"
features <- read.table(fileFeatures)
featuresMean <- features[grep("mean()", features$V2), ]
featureMean.index <- featuresMean[ ,1]
featuresStd <- features[grep("std()", features$V2), ]
featuresStd.index <- featuresStd[ ,1]
featuresWanted.index <- c(featureMean.index, featuresStd.index)
featuresWanted.name <- features[featuresWanted.index, 2]

# Extract columns for wanted features and assign column names 
XMergeWanted <- XMerge[ , featuresWanted.index]
colnames(XMergeWanted) <- featuresWanted.name
DataMergeWanted <- cbind(SubjectMerge, YMerge, XMergeWanted)
colnames(DataMergeWanted) <- c("Subject", "Activity", as.character(featuresWanted.name))


## Step 3: Uses descriptive activity names to name the activity in the data set.
fileActivity <- "./activity_labels.txt"
activityLabels <- read.table(fileActivity)
activityLabels.name <- as.character(activityLabels[ ,2])
DataMergeWanted$Activity <- factor(DataMergeWanted$Activity, labels = activityLabels.name)


## Step 4: Appropriately labels the data set with descriptive variable names.


## Step 5: From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.
DataMelt <- melt(DataMergeWanted, id = c("Subject", "Activity"), measure.vars = featuresWanted.name)
DataTidy <- dcast(DataMelt, Subject + Activity ~ variable, mean)

write.table(DataTidy, file = "tidy_data.txt", row.names = TRUE, quote = FALSE)

