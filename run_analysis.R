fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip?accessType=DOWNLOAD"

setwd("u:")

if (!file.exists("data")) {
  dir.create("data")
}

download.file(fileUrl, destfile="u:/read_get_data.zip",mode="wb")

unzip("u:/read_get_data.zip",exdir="u:/data")

library(plyr)

##step 1 - use read.table to read in extracted files from train and test

##x_train contains the data records
x_train<-read.table("U:/data/UCI HAR Dataset/train/X_train.txt")

##y_train contains the activity label codes for the training data records
y_train<-read.table("U:/data/UCI HAR Dataset/train/y_train.txt")
names(y_train)[1]<-"Activity_code"

##subj_train contains the subject labels
subj_train<-read.table("U:/data/UCI HAR Dataset/train/subject_train.txt")
names(subj_train)[1]<-"Subject_code"

##x_test contains the data records
x_test<-read.table("U:/data/UCI HAR Dataset/test/X_test.txt")

##y_test contains the activity label codes for the test data records
y_test<-read.table("U:/data/UCI HAR Dataset/test/y_test.txt")
names(y_test)[1]<-"Activity_code"

##subj_test contains the subject labels
subj_test<-read.table("U:/data/UCI HAR Dataset/test/subject_test.txt")
names(subj_test)[1]<-"Subject_code"

##bring all the training data together
train_all<-cbind(subj_train,y_train,x_train)

##bring all the test data together
test_all<-cbind(subj_test,y_test,x_test)

##label the data so we know which records come from which original set
test_all<-cbind("Test",test_all)
train_all<-cbind("Training",train_all)
names(test_all)[1]<-"data_type"
names(train_all)[1]<-"data_type"

##stack the data to create a single dataset

all_data<-rbind(train_all,test_all)

##read in activity labels
activity_label<-read.table("U:/data/UCI HAR Dataset/activity_labels.txt")
names(activity_label)<-c("Activity_code","Activity_label")

##merge activity labels to all_data - do this at the end to avoid ordering issues
all_data<-merge(all_data,activity_label,by="Activity_code")

library(reshape)

##create a tall dataset to more easily understand available fields
melt_data<-melt(all_data,id=c("data_type","Subject_code","Activity_code","Activity_label"))
melt_data<-melt_data[order(melt_data$data_type,melt_data$Subject_code,melt_data$Activity_code,melt_data$variable),]
colnames(melt_data)[colnames(melt_data)=="variable"]<-"Feature_ID"

##remove "v" from Feature_ID in the dataset to enable merging
melt_data$Feature_ID<-gsub("V","",melt_data$Feature_ID)
## Step 2 - extract only the measurements on the mean and std for each measurement

features<-read.table("U:/data/UCI HAR Dataset/features.txt")
names(features)<-c("Feature_ID","Feature_label")

final_data<-merge(melt_data,features,by="Feature_ID")

## step 2 get only columns with mean() or std() in their names

## get mean data first - careful not to get meanFreq as well
mean_data<-final_data[grep("mean()",final_data$Feature_label),]

##get std data
std_data<-final_data[grep("std",final_data$Feature_label),]

##stack to give both in one dataset
mean_std_data<-rbind(mean_data,std_data)

##step 3 - achieved in lines 56 to 60 of code

##step 4 - achieved on a ongoing basis throughout code

##step 5 - create a second, independent tidy data set with the average of each variable
##for each activity and each subject

##use ddply from plyr to summarize by group
average_data <- ddply(mean_std_data,c("Subject_code","Activity_code","Activity_label"),summarise,Mean=mean(value))

##write out table to text file
write.table(average_data, "average_data.txt", row.name=FALSE)