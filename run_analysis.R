##STEP 1 - Merge the training and the test sets to create one data set.

#read in column headers from "features" data file
headers<-read.table("features.txt")

#read in train and test data files, assigning the column header variables 
train<-read.table("X_train.txt", col.names=headers$V2)
test<-read.table("X_test.txt", col.names=headers$V2)

#read in "labels" data file
labels_test<-read.table("y_test.txt")
labels_train<-read.table("y_train.txt")

#read in "subject" data file
subject_train<-read.table("subject_train.txt")
subject_test<-read.table("subject_test.txt")

#combine activity labels and subject informatoin with the data set for both train and test
full_train<-cbind(subject_train, labels_train, train)
full_test<-cbind(subject_test, labels_test, test)

#Combine the full test and full train data files to complete step 1
full_data<-rbind(full_train, full_test)

##STEP 2 - Extract only the measurements on the mean and standard deviation for each measurement.

#Determine which column variables house measurements on the mean and standard deviation.
mean_std<-grep("\\.mean\\.|\\.std\\.", names(full_data))

#Add column 1 and 2 to the subset of columns list.
subset<-c(1, 2, mean_std)

#Extract only the columns flagged in 'subset" to "subset_data".
subset_data<-full_data[,subset]


##STEP 3 - Use descriptive activity names to name the activities in the data set

#Read in activity labels.
activity_labels<-read.table("activity_labels.txt")

#Convert labels (column 2) to activity factor text.
subset_data[,2]<-factor(subset_data[,2],levels=activity_labels$V1, labels=activity_labels$V2)

##STEP 4 - Appropriately label the data set with descriptive variable names.

#Replace V1 with "Subject" variable name.  
#Need to exclude V1.1 so use $ function to incidate the text comes at the end of the name.
names(subset_data)<-sub("V1$","Subject",names(subset_data))
#Replace V1.1 with "Activity"
names(subset_data)<-sub("V1\\.1","Activity",names(subset_data))
#Replace periods with spaces
names(subset_data)<-gsub("\\."," ",names(subset_data))
#Remove extra spaces
names(subset_data)<-str_trim(names(subset_data))
#Update variable names that start with 't' to start with "Time ". 
#Use 'sub' functiont only replace first instance.
names(subset_data)<-sub("^t","Time ",names(subset_data))
#Update variable names that start with 'f' to start with "Freq ". 
#Use 'sub' functiont only replace first instance.
names(subset_data)<-sub("^f","Freq ",names(subset_data))
#Update the order of the X/Y/Z portion and the mean/std portion of variable name.
names(subset_data)<-sub("mean( )*X","X axis Mean",names(subset_data))
names(subset_data)<-sub("mean( )*Y","Y axis Mean",names(subset_data))
names(subset_data)<-sub("mean( )*Z","Z axis Mean",names(subset_data))
names(subset_data)<-sub("std( )*X","X axis Std",names(subset_data))
names(subset_data)<-sub("std( )*Y","Y axis Std",names(subset_data))
names(subset_data)<-sub("std( )*Z","Z axis Std",names(subset_data))


##STEP 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Load dplyr library
library(dplyr)

#Use a multi step process using dplyr functions
#First, note that the functions will be applying to "subset_data".
#Then, group by Subject and Activity.
#Next, summarize the mean and standard deviation for all variables in subset_data starting with column 3.
  #Start with column 3 since the first 2 columns are Subject and Activity.
#Save the resulting table in the data table "mean_std_table".
mean_std_table<-subset_data %>%
    group_by(Subject, Activity) %>%
    summarize_at(names(subset_data)[3:ncol(subset_data)], lst(mean, sd))

#Save table to a file named "mean_std_table".
write.table(mean_std_table, file="mean_std_table.txt", row.names=FALSE)