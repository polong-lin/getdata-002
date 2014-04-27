getdata-002
===========

For the "Getting and Cleaning Data" course in the Data Science Specialization


The script, "run_analysis.R", should be run in the working directory of the UCI HAR Dataset.

run_analysis.R does this following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

It will generate two outputs:
- the first output, "dataoutput.txt" contains all the means and standard deviations for all features collected by the hardware
  - it will also contain the subject id and the activity they were performing during the measurement

- the second output, "tidydata.txt", contains the average of each variable for each activity and each subject.
  - note that the column names have be renamed to start with "Avg." to reflect that these values are averages of corresponding raw data from dataoutput.txt

Both outputs are written to the working directory.


