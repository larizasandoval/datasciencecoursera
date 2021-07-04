##THIS SCRIPT WAS DONE ON WINDOWS SYSTEM

##previously we had to download the data and unzip it.

##THE WORKING DIRECTORY IS "UCI HAR Dataset"



#STEP 1: Merges the training and the test sets to create one data set.

    #1.1: Read the txt files in the follow way
        xtrain <- read.table(".\\train\\X_train.txt")
        ytrain <- read.table(".\\train\\Y_train.txt")
        subject_train <- read.table(".\\train\\subject_train.txt")
        xtest <- read.table(".\\test\\X_test.txt")
        ytest <- read.table(".\\test\\y_test.txt")
        subject_test <- read.table(".\\test\\subject_test.txt")
        features <- read.table(".\\features.txt")
        activity_labels <- read.table(".\\activity_labels.txt")
        
    #1.2: assign names to columns 
        names(xtrain) <- features[,2]
        names(ytrain) <- "activityID"
        names(subject_train) <- "subjectID"
        names(xtest) <- features[,2]
        names(ytest) <- "activityID"
        names(subject_test) <- "subjectID"
        names(activity_labels) <- c("activityID","activityName")
        
    #1.3: merging all data
        merge_train <- cbind(ytrain,subject_train,xtrain)
        merge_test <- cbind(ytest,subject_test,xtest)
        merge_train_test <- rbind(merge_train,merge_test)


#STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

    mean_standar <- merge_train_test[,grep("(activityID)|(subjectID)|(mean..)|(std..)",names(merge_train_test))]

#STEP 3: Uses descriptive activity names to name the activities in the data set

    setWithActivityNames <- merge(mean_standar,activity_labels,by="activityID",all.x = TRUE)
    setWithActivityNames <- subset(setWithActivityNames,select = c(length(setWithActivityNames),(1:length(setWithActivityNames)-1)))

#STEP 4: Appropriately labels the data set with descriptive variable names

    #done in lines 23,24,26,27,28

#STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
    #5.1: I have used the dplyr package

        library(dplyr) ##previously installed
    
    #5.2: Group and order data
    
        final_data <- group_by(setWithActivityNames,activityID,subjectID,activityName)
        final_data <- arrange(final_data,activityID,subjectID,activityName)
    
    #5.3 : Average each varible for each activity and each subject
        
        final_data <- summarise_at(final_data,names(final_data)[4:length(final_data)],mean)

    #5.4: make a txt file with the final tidy data
        
        write.table(final_data, "final_tidy_data.txt", row.name=FALSE)

