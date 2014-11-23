### Overview

This README.md file explains how all of the scripts work and how they are connected. 

The purpose of this project is to demonstrate and ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

For the peroject, the following have been submitted: 
1. `getdata009_Project_tidyDataFile.txt`: a tidy data set as described below, submitted to Coursera
2. `run_analysis.R`: the script for performing the analysis, uploaded to this repo
3. `CodeBook.md`: a code book that describes the variables, the data, and any transformations or work performed to clean up the data, uploaded to this repo


### Background to the task

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the Coursera Getting and Collecting Data course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


### Getting started

To run the scripts, do the following in an R environment:
> source("run_analysis.R")

To load and view the data, do the following in an R environment:
> data <- read.table("getdata009_Project_tidyDataFile.txt", header = TRUE)

> View(data)


### How the scripts work

The scripts are arranged in the following steps:

* Step 1: loading and and merging the training and test data sets
  * Here and throughout, where possible tools from the `data.table` library were used.
  * Note also that Step 4 was implemented at this stage, so that descriptive lables were able to be used in Step 2, which greatly simplified the latter.
* Step2: extracting only the measurements on the mean and standard deviation for each measurement
  * This was carried out by creating an index using the "grepl" function (matching column names containing terms "mean", "std", "subjs" or "activities"), and then using this index with the "subset" function.
* Step3: setting descriptive activity names to name the activities in the data set
  * A look-up dictionary was created using the list of activity labels (from 'activity_labels.txt' in the original data set), and then "sapply" was used to replace the number values with the appropriate character values labelling each activity.
* Step4: setting appropriately descriptive labels for the measurement variables
  * Carried out during Step 1.
* Step5: From the original data set in step 4, a second, independent tidy data set with the average of each variable for each activity and each subject was created.
  * Using tools from the `data.table` library, all retained measurement variables were averaged, grouped by subject and type of activity. 
  * A text file "getdata009_Project_tidyDataFile.txt" is written, containing the data from this step.


