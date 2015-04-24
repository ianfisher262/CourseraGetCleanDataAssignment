#This file contains information regarding the variables, data and transformations made to produce the average_data.txt file
##Origin of the data in average_data.txt
###The raw data from which average_data.txt was derived is from wearable fitness data collection devices and was obtained via the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
###The raw data contains training and test datasets with seperate files for activities for which data was collected, subject ID information, information on the exact measurements made by the wearable devices and the measurement data itself
###Further information on the collection of such data is available via this link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
##Variables in average_data.txt
###Subject_code: Number between 1 and 30 indicating the subject to whom the observation relates
###Activity_code: Number between 1 and 6 indicating the code applied to the activity to which the observation relates
###Activity_label: Text string indicating the name of the activity to which the observation relates
##Transformations made to raw data to create average_data.txt
###1 - training and data data were merged with labelling data and subject ID datasets, before combining the test and training data into a single file
###2 - the data was transpose from a wide to long dataset to aid summarizing
###3 - the data was subset to select only the mean and standard deviations of each measurment of each activity
###4 - this subset of data was then summarized to create a dataset containing the subject and activity level mean values presented in average_data.txt
