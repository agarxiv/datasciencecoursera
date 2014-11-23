### Overview

This CodeBook.md describes the variables, the original data, and transformations and work performed to clean up the data, and also the final data set which our scripts generate.

Our data set is a subset of the "Human Activity Recognition Using Smartphones Dataset, Version 1.0" (HARUSD), described below. Our subset includes averages of all measurements of activities undertaken by subjects during the HARUSD collection.

Here is a list of sections that follow:

1. Background
2. Data, including details about transformations of data
3. Variables

See the accompanying READMe.md file for instructions about running the scripts.


### Background

The data set that was used is the "Human Activity Recognition Using Smartphones Dataset, Version 1.0", by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. The data is archived here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

For a detailed background, including other useful information, see the 'README.txt' that comes with the orginal data set. Briefly, the data is from an experiment with a group of 30 volunteers, with age range 19-48 years. Subjects each performed six activities ("WALKING"", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"), while wearing a smartphone (Samsung Galaxy S II) on the waist. For these activities, 3-axial linear acceleration and 3-axial angular velocity were captured. The dataset was then randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. For more information, see the original data set, in particular, the 'features_info.txt' file.

From the original data set, the following files were used in developing our data set:
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'train/subject_train.txt': Subject for each training observation.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'test/subject_test.txt': Subject for each test observation.


### Data

Our data set is drawn from the original HARUSD data set, where each observation in the data set includes:
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

Regarding formating of the HARUSD measurements:
* Features are normalized and bounded within [-1,1].
* Each feature vector is a row on the text file.

#### Transformations of the HARUSD data to make our data set:
* The training and the test sets have been merged (from 'train/X_train.txt' & 'train/X_test.txt').
* Column labels for measurement variables have been replaced with descriptive names (from 'features.txt').
* Only those measurement variables recording means and standard deviations of all observations have been retained (the rest were discarded).
* An activities column has been added with descriptive names for activities carried out by subjects, such as "WALKING", "LAYING", etc (from 'activity_labels.txt'). This column was derived by transforming an initial set of numeric labels of the activities (from 'train/y_train.txt' & 'test/y_test.txt').
* A column showing the subject for each observation has been added (from 'train/subject_train.txt' & 'test/subject_test.txt').
* Finally, all measurements for activities and subjects were averaged, and this is the figure recorded in the final data set.
* The final data table consists of 180 rows, i.e. 6 activities x 30 subjects.


### Variables

From the 561 variables HARUSD, only those pertaining to means and standard deviations were retained for the final data set, and these plus variables for subjects ("subjs") and descriptive names of activities ("activityNames") are listed below. The descriptive labels for the original HARUSD measurement variables are retained as these are usefully precise, and the following key will help in deciphering these:
* 't': referring to signals in time domain
* 'f': referring to Fast Fourier Transform (FFT) applied to some of the time domain signals
* '-XYZ': denotes 3-axial signals in the X, Y and Z directions
* 'Acc', 'Gyro': denote accelerometer and gyroscope measurements
* 'BodyAcc', 'GravityAcc': acceleration signal separated into body and gravity acceleration signals
* 'Jerk': body linear acceleration and angular velocity derived in time to obtain Jerk signals
* 'Mag': magnitude of three-dimensional signals calculated using the Euclidean norm

1. "subjs"
2. "activityNames"
3. "tBodyAcc-mean()-X"
4. "tBodyAcc-mean()-Y"
5. "tBodyAcc-mean()-Z"
6. "tBodyAcc-std()-X"
7. "tBodyAcc-std()-Y"
8. "tBodyAcc-std()-Z"
9. "tGravityAcc-mean()-X"
10. "tGravityAcc-mean()-Y"
11. "tGravityAcc-mean()-Z"
12. "tGravityAcc-std()-X"
13. "tGravityAcc-std()-Y"
14. "tGravityAcc-std()-Z"
15. "tBodyAccJerk-mean()-X"
16. "tBodyAccJerk-mean()-Y"
17. "tBodyAccJerk-mean()-Z"
18. "tBodyAccJerk-std()-X"
19. "tBodyAccJerk-std()-Y"
20. "tBodyAccJerk-std()-Z"
21. "tBodyGyro-mean()-X"
22. "tBodyGyro-mean()-Y"
23. "tBodyGyro-mean()-Z"
24. "tBodyGyro-std()-X"  
25. "tBodyGyro-std()-Y"
26. "tBodyGyro-std()-Z"
27. "tBodyGyroJerk-mean()-X"
28. "tBodyGyroJerk-mean()-Y"
29. "tBodyGyroJerk-mean()-Z"
30. "tBodyGyroJerk-std()-X"
31. "tBodyGyroJerk-std()-Y"
32. "tBodyGyroJerk-std()-Z"
33. "tBodyAccMag-mean()"
34. "tBodyAccMag-std()"
35. "tGravityAccMag-mean()"
36. "tGravityAccMag-std()"
37. "tBodyAccJerkMag-mean()"
38. "tBodyAccJerkMag-std()"
39. "tBodyGyroMag-mean()"
40. "tBodyGyroMag-std()"
41. "tBodyGyroJerkMag-mean()"
42. "tBodyGyroJerkMag-std()"
43. "fBodyAcc-mean()-X"
44. "fBodyAcc-mean()-Y"
45. "fBodyAcc-mean()-Z"
46. "fBodyAcc-std()-X"
47. "fBodyAcc-std()-Y"
48. "fBodyAcc-std()-Z"   
49. "fBodyAcc-meanFreq()-X"
50. "fBodyAcc-meanFreq()-Y"
51. "fBodyAcc-meanFreq()-Z"
52. "fBodyAccJerk-mean()-X"          
53. "fBodyAccJerk-mean()-Y"
54. "fBodyAccJerk-mean()-Z"
55. "fBodyAccJerk-std()-X"
56. "fBodyAccJerk-std()-Y"
57. "fBodyAccJerk-std()-Z"
58. "fBodyAccJerk-meanFreq()-X"
59. "fBodyAccJerk-meanFreq()-Y"
60. "fBodyAccJerk-meanFreq()-Z"
61. "fBodyGyro-mean()-X"
62. "fBodyGyro-mean()-Y"
63. "fBodyGyro-mean()-Z"
64. "fBodyGyro-std()-X"
65. "fBodyGyro-std()-Y"
66. "fBodyGyro-std()-Z"
67. "fBodyGyro-meanFreq()-X"
68. "fBodyGyro-meanFreq()-Y"         
69. "fBodyGyro-meanFreq()-Z"
70. "fBodyAccMag-mean()"
71. "fBodyAccMag-std()"
72. "fBodyAccMag-meanFreq()"         
73. "fBodyBodyAccJerkMag-mean()"
74. "fBodyBodyAccJerkMag-std()"
75. "fBodyBodyAccJerkMag-meanFreq()"
76. "fBodyBodyGyroMag-mean()"
77. "fBodyBodyGyroMag-std()"
78. "fBodyBodyGyroMag-meanFreq()"
79. "fBodyBodyGyroJerkMag-mean()"
80. "fBodyBodyGyroJerkMag-std()"
81. "fBodyBodyGyroJerkMag-meanFreq()"
