#README
This is the REAME file of the Github repository associated to the “Getting and Cleaning Data Course Project”.


##Files included in the repository
- 'README.md':	This file. Description of the algorithm.
- 'run_analysis.R':	Script in R to perform the analysis.
- 'CodeBook.md':	Description of the variables and values of the resulting tidy data set.


##Necessary external files
The program requires the data from the project “Human Activity Recognition Using Smartphones Dataset” version 1.0. This data were collected during an experiment carried out with a group of 30 volunteers. Each person performed six different activities wearing a smartphone (Samsung Galaxy S II) on the waist. The measurements were taken with its embedded accelerometer and gyroscope. They captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate.

A detailed description of the experiment can be found on the website of the project:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The necessary data can be downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


##Description of the input files
The data of the measurements were originally partitioned into two sets and stored in different directories, namely the “train” directory and the “test” directory. For the purpose of the analysis of the current work no distinction is made between both data sets.

The input files are:
- 'test/subject_test.txt' and 'train/subject_train.txt':  Each row is a number from 1 to 30 that identifies the subject of the experiment.
- 'test/X_test.txt' and 'train/X_train.txt': Observation of 561 time and frequency domain variables. They provided the triaxial acceleration from the accelerometer, the estimated body acceleration and the triaxial angular velocity from the gyroscope. The values are normalized and bounded within [-1,1].
- 'test/y_test.txt' and 'train/y_train.txt': Identification number of the activity being performed by the subject during the observations. This labels are in the range from 1 to 6.
- 'activity_labels.txt': Links the identification number with the name of the activity.
- 'features.txt': List of all measured features.


##Description of the algorithm
The 'run_analysis.R' script has a single function called 'run_analysis' that does not have any argument. The program requires the Samsung data to be placed in the working directory. 

The output of the program is a data frame that contains the subject identification number, the activity name and, as requested, the average of each measurement of the mean and standard deviation for each activity and each subject. The output meets the tidy data principles as each measured variable is in one column and each observation in a different row. Following the indication of the TAs, the variable names are not decomposed.

###How the script works, step by step:
1) The program reads each one of the input files (see previous section) and creates a new object for each one of them.

2) In this analysis there is no reason to distinguish between the training set and the test set. For this reason, and following the tidy data principle that says that there should be one table for each kind of variable, both sets are merged to form a single data frame.

First, the objects with the subject identification number, the activity labels and the measured variables are combined by columns for both the test set and the training set. This gives two new data frames containing all the information from each set. Then, these two sets are combined by rows to form a new data frame that contains all the information.

To make the following steps simpler, the columns are properly named at this point. Taking into account that names have to be descriptive, the column with the identification number of the subjects is called “Subject_id”, the column with the labels of the activities is called “Activities” and the columns with the measurements are called according to the original names that were read from the file 'features.txt'. 

Although it is not necessary for the analysis, the data frame is then reordered as a function of the identification number of the subject. Tides are broken using the activity labels. The final result of this step is a data frame called Data_Merged.

3) In this step the measurements that correspond to means or to standard deviations are extracted from the previos data frame (Data_Merged) . According to the file 'features_info.txt' these values are codified in the variable names as 'mean()' and 'std()'.  These patterns are searched for matches withing the names of the measured variables and those with a positive match are extracted to form a new data frame called Data_Mn_St. The columns “Subject_id” and “Activities” are also included in the new data frame.

4) To this point the activity labels from the column “Activities” are still codified according to their identification numbers.  In this step the activity labels are translated from their original numeric form into the name of the activity using the information from the file 'activity_labels.txt'.

5) The last step consists in calculating the average of each value for each subject and activity. To do that, the duplicated() function is used to generate a new data frame (Data_Aver) without duplicated pars “Subject_id”-”Activity”. This provides a data frame with the appropriate dimensions and with the correct “Subject_id” and “Activity” columns. The remaining columns will be filled with the averaged values.

To compute the average values it is necessary to know the rows of the data frame with the same combination of subject and activity. This is done creating two vectors, one pasting the “Subject_id” and ”Activity” columns from Data_Mn_St (called ind_Paste) and the other with its unique values (ind_Uniq). Then, in a for loop following the values along the vector ind_Uniq, the rows of Data_Mn_St with the same combination of subject and activity are found in ind_Paste. 

Once the rows are known, all averaged values can be calculated simultaneously for every column using the function colMeans(). The final result is the data frame Data_Aver. A detailed description of its variables an values can be found in the 'CodeBook.txt' file.
