---
title: "Getting and Cleaning Data Project - Codebook"
author: "Daniel Rees"
date: "05/17/2020"
output:
  html_document:
    keep_md: yes
---

## Project Description

Project is based on data provided from: Human Activity Recognition Using Smartphones Dataset Version 1.0

Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws


##Study design and data processing

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

###Collection of the raw data

For each record the following is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


###Notes on the original (raw) data 

The original data includes:
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'X_train.txt': Training set.
- 'y_train.txt': Training labels.
- 'X_test.txt': Test set.
- 'y_test.txt': Test labels.
- 'subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

##Creating the tidy datafile

Summary of process performed in 'run_analysis.R
==================================================
Step 1: Merge the training and the test sets to create one data set.

  - The 'feature.txt' file is loaded to data table "headers" to store the initial column header names.
  - The 'x_train.txt' and 'X_test.txt' files are loaded to data tables "train" and "test" respectively with "headers" used to add column headers.
  - The 'y_train.txt' and 'y_test.txt' files are loaded to data tables "labels_train" and "labels_test" respectively.
  - The 'subject_train.txt' and 'subject_test.txt' files are loaded to data tables with the same names.
  - The three train files are combined together and the three test files are combined together into new data tables "full_train" and "full_test" respectively.  This process used the cbind function since all three files have the same observations.
  - The "full_train" and "full_test" files are combined together into new data table "full_data".  This process used the rbind function since both files have the same column variables.  This data table contains the full data set.


Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

  - Determine what columns in the "full_test" data table represent mean and standard deviation information.
  - Based on the informatoin in the file 'features_info.txt', the mean and standard deviation information is housed in variables with "mean()" and "std()" text in their names.
  - Use the grep function to determine what header names in the "full_data" have either "mean()" or "std()". This information stored in the data field "mean_std".
      - This function should use '\\.mean\\.|\\.std\\.' because we want to exclude fields that have the word mean or std but not in the format ".mean.".  This is based on the naming convention described in 'features_info.txt' and how it is converted to variable names.
  - The subset of the data should also include column 1 and 2 which house the training and subject data.
  - The subset of the columns is stored in the field "subset" by combining "mean_std" and 1 and 2.
  - The subset of the "full_data" is stored in the data table "subset_data" by applying the "subset" variable.
  
  
  Step 3: Use descriptive activity names to name the activities in the data set
  
    - Read in activity names to data table "activity_labels" from 'activity_labels.txt'.
    - Convert the labels values (column 2 of subset_data) to descripitve activity names using the factor function.
    
    
  Step 4: Appropriately label the data set with descriptive variable names.
  
    - Replace V1 with "Subject" variable name.
        - Need to exclude V1.1 so use $ function to incidate the text comes at the end of the name.
    - Replace V1.1 with "Activity"
    - Replace periods with spaces to allow name to be easier to read.
    - Trim any extra spaces from variable names.
    - Update variable names that start with 't' to start with "Time ". 
    - Update variable names that start with 'f' to start with "Freq ". 
        - These variables represent the frequency based on a Fast Fourier Transform.  However, to balance the length vs. clarify of variable name a compromise of 'Freq' will be used.
    - Update the order of the X/Y/Z portion and the mean/std portion of variable name.
  

  Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    - Load dplyr library.
    - Use a multi step process using dplyr functions
        - First, note that the functions will be applying to "subset_data".
        - Then, group by Subject and Activity.
        - Next, summarize the mean and standard deviation for all variables in subset_data starting with column 3.
            - Start with column 3 since the first 2 columns are Subject and Activity.
    - Save the resulting table in the data table "mean_std_table".
    - Save table to a file named "mean_std_table".

##Description of the variables in the "mean_std_table" file

General description of the file including:
 - 180 observations of 134 variables
 - Observations include all possible combinations of the 30 subjects and the 6 activities.
 - Variables include Subject, Activity, and the mean and standard deviation calculations for the 66 variables pulled from the original dataset.

Variable 1 - Subject
  Class - Numeric
  Values - Range 1 to 30
  Notes - Represents the subject in the study.

Variable 2 - Activity
  Class - Factor
  Values - Six levels (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
  Notes - Represents the activity levels included in the study.

####Notes on variables 3 through 180:

The variable names include detail about the data included.  The following will apply to all of the variables 3 through 180:
  - Variables ending with "\_mean" are the mean of the values in the larger data set for that given combination of Subject and Activity.
  - Variables ending with "\_sd" are the standard deviation of the values in t he larger data set for that given combination of Subject and Activity.
  - The remainder of the variable names are from the variable names of the larger data set.
  - The variable names from the larger data set also used abbreviated terminology throughout to allow for easier coding while maintaining variable recognition.
      - Variables starting with "Time" are time based values.
      - Variables starting with "Freq" are frequency based values.
      - Variables with "Body" in the name refer to body motion components.
      - Variables with "Gravity" in the name refer to gravitational motion components.
      - Variables with "Acc" in the name refer to measurements from the accelerometer.
      - Variables with "Gyro" in the name refer to measurements from the gyroscope.
      - Variables for measurements along either the X, Y, or Z axis are noted as such in their names.
      - Variables with "Jerk" in the name refer to jerk motions measurements.
      - Variables with "Mag" in the name refer to magnitude measurements.
      - Variables with "Mean" before the underscore indicates the values in the larger data set were mean calculations.
      - Variables with "std" before the underscore indicates the values in the larger data set were standard deviation calculations.
  - All variables from 3 through 180 are numeric.
  - All variables from 3 through 180 were normalized and bounded within [-1,1]

Variables 3 through 180 are:

- Time BodyAcc X axis Mean_mean
- Time BodyAcc Y axis Mean_mean
- Time BodyAcc Z axis Mean_mean
- Time BodyAcc X axis Std_mean
- Time BodyAcc Y axis Std_mean
- Time BodyAcc Z axis Std_mean
- Time GravityAcc X axis Mean_mean
- Time GravityAcc Y axis Mean_mean
- Time GravityAcc Z axis Mean_mean
- Time GravityAcc X axis Std_mean
- Time GravityAcc Y axis Std_mean
- Time GravityAcc Z axis Std_mean
- Time BodyAccJerk X axis Mean_mean
- Time BodyAccJerk Y axis Mean_mean
- Time BodyAccJerk Z axis Mean_mean
- Time BodyAccJerk X axis Std_mean
- Time BodyAccJerk Y axis Std_mean
- Time BodyAccJerk Z axis Std_mean
- Time BodyGyro X axis Mean_mean
- Time BodyGyro Y axis Mean_mean
- Time BodyGyro Z axis Mean_mean
- Time BodyGyro X axis Std_mean
- Time BodyGyro Y axis Std_mean
- Time BodyGyro Z axis Std_mean
- Time BodyGyroJerk X axis Mean_mean
- Time BodyGyroJerk Y axis Mean_mean
- Time BodyGyroJerk Z axis Mean_mean
- Time BodyGyroJerk X axis Std_mean
- Time BodyGyroJerk Y axis Std_mean
- Time BodyGyroJerk Z axis Std_mean
- Time BodyAccMag mean_mean
- Time BodyAccMag std_mean
- Time GravityAccMag mean_mean
- Time GravityAccMag std_mean
- Time BodyAccJerkMag mean_mean
- Time BodyAccJerkMag std_mean
- Time BodyGyroMag mean_mean
- Time BodyGyroMag std_mean
- Time BodyGyroJerkMag mean_mean
- Time BodyGyroJerkMag std_mean
- Freq BodyAcc X axis Mean_mean
- Freq BodyAcc Y axis Mean_mean
- Freq BodyAcc Z axis Mean_mean
- Freq BodyAcc X axis Std_mean
- Freq BodyAcc Y axis Std_mean
- Freq BodyAcc Z axis Std_mean
- Freq BodyAccJerk X axis Mean_mean
- Freq BodyAccJerk Y axis Mean_mean
- Freq BodyAccJerk Z axis Mean_mean
- Freq BodyAccJerk X axis Std_mean
- Freq BodyAccJerk Y axis Std_mean
- Freq BodyAccJerk Z axis Std_mean
- Freq BodyGyro X axis Mean_mean
- Freq BodyGyro Y axis Mean_mean
- Freq BodyGyro Z axis Mean_mean
- Freq BodyGyro X axis Std_mean
- Freq BodyGyro Y axis Std_mean
- Freq BodyGyro Z axis Std_mean
- Freq BodyAccMag mean_mean
- Freq BodyAccMag std_mean
- Freq BodyBodyAccJerkMag mean_mean
- Freq BodyBodyAccJerkMag std_mean
- Freq BodyBodyGyroMag mean_mean
- Freq BodyBodyGyroMag std_mean
- Freq BodyBodyGyroJerkMag mean_mean
- Freq BodyBodyGyroJerkMag std_mean
- Time BodyAcc X axis Mean_sd
- Time BodyAcc Y axis Mean_sd
- Time BodyAcc Z axis Mean_sd
- Time BodyAcc X axis Std_sd
- Time BodyAcc Y axis Std_sd
- Time BodyAcc Z axis Std_sd
- Time GravityAcc X axis Mean_sd
- Time GravityAcc Y axis Mean_sd
- Time GravityAcc Z axis Mean_sd
- Time GravityAcc X axis Std_sd
- Time GravityAcc Y axis Std_sd
- Time GravityAcc Z axis Std_sd
- Time BodyAccJerk X axis Mean_sd
- Time BodyAccJerk Y axis Mean_sd
- Time BodyAccJerk Z axis Mean_sd
- Time BodyAccJerk X axis Std_sd
- Time BodyAccJerk Y axis Std_sd
- Time BodyAccJerk Z axis Std_sd
- Time BodyGyro X axis Mean_sd
- Time BodyGyro Y axis Mean_sd
- Time BodyGyro Z axis Mean_sd
- Time BodyGyro X axis Std_sd
- Time BodyGyro Y axis Std_sd
- Time BodyGyro Z axis Std_sd
- Time BodyGyroJerk X axis Mean_sd
- Time BodyGyroJerk Y axis Mean_sd
- Time BodyGyroJerk Z axis Mean_sd
- Time BodyGyroJerk X axis Std_sd
- Time BodyGyroJerk Y axis Std_sd
- Time BodyGyroJerk Z axis Std_sd
- Time BodyAccMag mean_sd
- Time BodyAccMag std_sd
- Time GravityAccMag mean_sd
- Time GravityAccMag std_sd
- Time BodyAccJerkMag mean_sd
- Time BodyAccJerkMag std_sd
- Time BodyGyroMag mean_sd
- Time BodyGyroMag std_sd
- Time BodyGyroJerkMag mean_sd
- Time BodyGyroJerkMag std_sd
- Freq BodyAcc X axis Mean_sd
- Freq BodyAcc Y axis Mean_sd
- Freq BodyAcc Z axis Mean_sd
- Freq BodyAcc X axis Std_sd
- Freq BodyAcc Y axis Std_sd
- Freq BodyAcc Z axis Std_sd
- Freq BodyAccJerk X axis Mean_sd
- Freq BodyAccJerk Y axis Mean_sd
- Freq BodyAccJerk Z axis Mean_sd
- Freq BodyAccJerk X axis Std_sd
- Freq BodyAccJerk Y axis Std_sd
- Freq BodyAccJerk Z axis Std_sd
- Freq BodyGyro X axis Mean_sd
- Freq BodyGyro Y axis Mean_sd
- Freq BodyGyro Z axis Mean_sd
- Freq BodyGyro X axis Std_sd
- Freq BodyGyro Y axis Std_sd
- Freq BodyGyro Z axis Std_sd
- Freq BodyAccMag mean_sd
- Freq BodyAccMag std_sd
- Freq BodyBodyAccJerkMag mean_sd
- Freq BodyBodyAccJerkMag std_sd
- Freq BodyBodyGyroMag mean_sd
- Freq BodyBodyGyroMag std_sd
- Freq BodyBodyGyroJerkMag mean_sd
- Freq BodyBodyGyroJerkMag std_sd
