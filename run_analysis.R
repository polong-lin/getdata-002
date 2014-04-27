# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Good luck!

#Import train and test data
subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/Y_train.txt")
subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/Y_test.txt")


#Combine into one dataframe, label columns
train <- cbind(subject_train, y_train)
test <- cbind(subject_test, y_test)
data <- rbind(train, test)
names(data) <- c("Subject", "Activity")

#Remove unneeded variables from memory
subject_train <- NULL
y_train <- NULL
subject_test <- NULL
y_test <- NULL
train <- NULL
test <- NULL

#Replace numeric activity codes with labels
activity.code <- c(WALKING = 1, 
                  WALKING_UPSTAIRS = 2, 
                  WALKING_DOWNSTAIRS = 3, 
                  SITTING = 4, 
                  STANDING = 5, 
                  LAYING = 6)

data$Activity <- names(activity.code)[match(data$Activity, activity.code)] #replaces values in Activity with labels

###Need mean and std of each measurement
#Import data and combine into x_data
x_train <- read.table("train/X_train.txt")
x_test <- read.table("test/X_test.txt")
x_data <- rbind(x_train, x_test)

#Remove unneeded variables from memory
x_train <- NULL
x_test <- NULL

#Import features into dataframe
feats <- read.table("features.txt")

#Assign column (feature) labels to x_data from features.txt
names(x_data) <- feats$V2

#Find only the features that contain mean() or std()
match_meanstd <- c(".*mean\\(\\).*", ".*std\\(\\).*")
#matches <- grep(paste(match_meanstd, collapse="|"), feats$V2, value=TRUE) #gives names of features containing mean() or std()
matchesvalue <- grep(paste(match_meanstd, collapse="|"), feats$V2, value=FALSE) #gives numbers associated with the features containing mean() or std()

x_data_meanstd <- x_data[,matchesvalue]

#Combine Feature Data (x_data_meanstd) with Subject, Activity dataset (data)
data <- cbind(data, x_data_meanstd)

#Write dataframe to file
write.table(data, "dataoutput.txt") #note: this is not the tidy data output, which is written at the end of the script

### Take averages of the features, for each combination of Subject and Activity

data_bysubject <- split(data[,3:68], list(data$Subject, data$Activity))
data$SubjectActivity <- do.call(paste, c(data[c("Subject", "Activity")], sep = ""))

#split data by subject/activity combination
splitdata <- data.frame(lapply(split(data[,3:68], data[,69]), colMeans)) #get means by group (subject x activity)
splitdata <- t(splitdata) #transpose dataframe so features are columns
data.subjectactivity <- unique(data[,c(1,2)]) #get unique subject and activity columns from original data frame

finaldata <- cbind(data.subjectactivity, newdata) #combine subject, activity, and features.


#Write dataframe (finaldata) to tidydata.txt 
write.table(finaldata, file = "tidydata.txt")

