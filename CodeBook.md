The Web Site where the Data was sourced:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script:

Data Process / Pipeline:

#load test data

#unzip data

#load test data

#load subject data

#load features data

#load activity data

#(row) combine data
 
#add column names

#(col) combine data

#filter combined data
  # header like 'mean' AND like 'std'
  
#Add Activity Labels

 LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS
 
#Acc =>  Accelerometer Gyro => Gyroscope Mag => Magnitude ^t => Time ^f => Frequency BodyBody => Body
#Use rename (from RCookbook) - less error prone than 'manual' editing many column names

#reshape data where Activity(Activity Lbel) and Subject are the same.

#calculate mean for parameter combination and remove NA.
 
#produce step5 output
 


