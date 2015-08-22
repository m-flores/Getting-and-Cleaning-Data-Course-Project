#Reads de Samsung data and returns a tidy data set with the average of each entry that has 
#"mean()" and "std()" in its name. The average value is calculated for each activity and 
#each subject (see README.md and CodeBook.md for more information).

#The Samsung data have to be in the working directory.


run_analysis <- function(){
    
    #READ FILES.
     print("Reading files")
    
     Activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
     Features <- read.table("UCI HAR Dataset/features.txt")
    
     Data_test <- read.table("UCI HAR Dataset/test/X_test.txt")
     Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
     Activities_test <- read.table("UCI HAR Dataset/test/y_test.txt")
     
     Data_train <- read.table("UCI HAR Dataset/train/X_train.txt")
     Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
     Activities_train <- read.table("UCI HAR Dataset/train/y_train.txt")
     
     print("done")
    #---
     
     
    #COMBINE READ DATA, MERGE TRAINING AND TEST SETS, NAME COLUMNS AND REORDER THE RESULT
     Data_test2 <- cbind(Subject_test, Activities_test, Data_test)
     Data_train2 <- cbind(Subject_train, Activities_train, Data_train)
     
     Data_Merged <- rbind(Data_test2, Data_train2)
     
     colnames(Data_Merged) <- c("Subject_id", "Activity", as.character(Features[,2]))
     
     Data_Merged <- Data_Merged[order(Data_Merged$Subject_id, Data_Merged$Activity),]
    #---
     
     
    #EXTRACT MEANS AND STANDARD DEVIATIONS (in addition to Subject_id and Activity)
     Data_Mn_St <- cbind( Data_Merged[, names(Data_Merged) == "Subject_id" | names(Data_Merged) == "Activity"],
                          Data_Merged[, grepl("mean()", names(Data_Merged), fixed = T)], 
                          Data_Merged[, grepl("std()",  names(Data_Merged), fixed = T)])
    #---
     
     
    #NAME ACTIVITIES WITH ACTIVITY NAMES
     Data_Mn_St$Activity <- Activity_Labels[Data_Mn_St$Activity,2]
    #---
     
     
    #THE LABELLING OF THE DATA SET WITH DESCRIPTIVE NAMES WAS DONE BEFORE MERGING (LINE 27)
     
     
    #NEW DATASET WITH THE AVERAGE OF EACH VALUE FOR EACH SUBJECT AND ACTIVITY
     Data_Aver <- Data_Mn_St[!duplicated(Data_Mn_St[,1:2]), ]
     Data_Aver[,3:ncol(Data_Aver)] = NA  #Just to make an empty frame with de appropiate dimensions
     
     ind_Paste <- paste(Data_Mn_St$Subject_id, Data_Mn_St$Activity, sep = "_")   #Indexes combining subjects and activities
     ind_Uniq  <- unique(ind_Paste)                                              #Unique indexes

     for(i in seq_along(ind_Uniq)){
         ind_tmp <- ind_Uniq[i] == ind_Paste
         Data_Aver[i,3:ncol(Data_Aver)] <- colMeans(Data_Mn_St[ind_tmp,3:ncol(Data_Aver)])
     }
     
    #--- 
    
     
    Data_Aver   #Outputs the tidy data set with the averaged values.
}