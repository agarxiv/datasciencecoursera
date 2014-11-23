#####################################################
#
# For description of the following scripts, see "README.md" and "CodeBook.md"
#
#####################################################


#####################################################
# Load libraries
suppressMessages(library(data.table))
#####################################################


#####################################################
# Step 1. Merges the training and the test sets to create one data set.

#  Load training and the test data sets
training_data <- data.table(read.table("dataset/train/X_train.txt"))
training_labels <- data.table(read.table("dataset/train/y_train.txt"))
training_subjs <- data.table(read.table("dataset/train/subject_train.txt"))
testing_data <- data.table(read.table("dataset/test/X_test.txt"))
testing_labels <- data.table(read.table("dataset/test/y_test.txt"))

#  Add columns to each data set for subjects
training_data[,subjs:=training_subjs]
testing_data[,subjs:=testing_subjs]

#  Add columns to each data set for activities
training_data[,activities:=training_labels]
testing_data[,activities:=testing_labels]

#  Combine data and labels for training and testing sets
data_set <- rbind(training_data, testing_data)

#  Provide descriptive names for measurement variables
#   NB. This is Step 4, carried out here as it greatly simplifies the task in Step 2
#   of extracting the mean and standard deviation for each measurement
feats <- read.table("dataset/features.txt")
setnames(data_set, names(subset(data_set, select=-c(subjs,activities))), as.character(feats$V2))
#####################################################


#####################################################
# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

#  NB. we are using the descriptive names for measurement variables provided in Step 1 (actually a requirement of Step 4).
idx_data_set_MeansSDs <- colnames(data_set)[grepl("mean|std|subjs|activities", colnames(data_set))]
data_set <- subset(data_set, select=idx_data_set_MeansSDs)
#####################################################


#####################################################
# Step 3. Uses descriptive activity names to name the activities in the data set

#  First create a dictionary for translating the activity numbers to labels
features_dictionary <- c("1"="WALKING", "2"="WALKING_UPSTAIRS", "3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING")

#  Then replace the activity numbers for more descriptive labels
data_set[,activityNames:=sapply(data_set$activities, function(x) features_dictionary[as.character(x)])]
#   Clean-up: remove superfluous "activities" column
data_set <- subset(data_set, select=-c(activities))

#  To test, try: `data_set$activityNames`
#####################################################


#####################################################
# Step 4. Appropriately labels the data set with descriptive variable names. 

#  NB. this was done in Step 1, as it meant that the approach in Step 2 could be simplified 
#  to using the grepl function to search descriptive column names containing terms "mean" and "std"

#####################################################


#####################################################
# Step 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
#  NB. subjects were added to the data set in Step 1

#  Can column bind these to the average of each variable for each activity
data_set <- data_set[, lapply(.SD,mean), by=list(subjs, activityNames)]

#  To test: try answering "What activity constitutes walking for subject 1?" 
#   Answer: walking_subject1 <- 
#     		data_set_Means_withSubjs[data_set_Means_withSubjs$activityNames=="WALKING" & data_set_Means_withSubjs$==1,]

#  Finally, writ the data to a file: "getdata009_Project_tidyDataFile.txt"
write.table(data_set,"getdata009_Project_tidyDataFile.txt",row.names=FALSE,quote=FALSE)
#####################################################
