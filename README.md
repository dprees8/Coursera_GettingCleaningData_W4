# Coursera_GettingCleaningData_W4
Coursera - Getting &amp; Cleaning Data - Week 4 Project

Introduction:
=============

Project is based on data provided from:
  Human Activity Recognition Using Smartphones Dataset
  Version 1.0

Additional detail about the expirement at the bottom of this document.


Original Data
======================================

- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'X_train.txt': Training set.
- 'y_train.txt': Training labels.
- 'X_test.txt': Test set.
- 'y_test.txt': Test labels.
- 'subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 70. 


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

Expirement Details:
===================
  ==================================================================
  Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
  Smartlab - Non Linear Complex Systems Laboratory
  DITEN - Università degli Studi di Genova.
  Via Opera Pia 11A, I-16145, Genoa, Italy.
  activityrecognition@smartlab.ws
  www.smartlab.ws
  ==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 


Data Notes: 
===========
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws


License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
