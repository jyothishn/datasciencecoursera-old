
#1. Merge the training and the test sets to create one data set.

## read traning and test data
x_training <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

y_training <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

subject_training <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Combines data table for both train and test by rows
X <- rbind(x_training, X_test)
y <- rbind(y_training, y_test)
sub <- rbind(subject_training, subject_test)

##2.Extract only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt")
# filter the rows with names containing mean or std
filteredIndices <- grep("-mean\\(\\)|-std\\(\\)", features[,2])
filteredX <- X[,filteredIndices]

# remove "(" and ")" from the column names and convert to lower case letters
names(filteredX) <- features[filteredIndices,2]
names(filteredX) <- gsub("\\(|\\)","",names(filteredX))
names(filteredX) <- tolower(names(filteredX))


##3.Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
#replace _ character and convert to lower case
activities[,2] <- gsub("_", "", tolower(as.character(activities[,2])))

# change column name in the y data set
y[,1] <- activities[y[,1],2]
names(y) <- "activity"


##4.Appropriately labels the data set with descriptive variable names
names(sub) <- "subject"

# all cleaned up data into a new table, cleanData
cleanData <- cbind(sub, y, filteredX)

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

temp <- cleanData[, 3:dim(cleanData)[2]] 
tidyDataAvg <- aggregate(temp,list(cleanData$subject, cleanData$activity), mean)
names(tidyDataAvg)[1] <- "subject"
names(tidyDataAvg)[2] <- "activity"

## cleanData has the tidy data we created in step 4, and tidyDataAvg has the averaged data from setp 5
# write to files
write.table(cleanData, "TidyDataFile.txt")
write.table(tidyDataAvg, "TidyDataFileWithAverage.txt", row.names=FALSE)
