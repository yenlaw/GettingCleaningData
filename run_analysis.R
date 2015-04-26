  #load test data

if(!file.exists("./alldata")){dir.create("./alldata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./alldata/Dataset.zip",method="curl")

  #unzip data

unzip("allData/Dataset.zip", exdir = "./alldata")

  #load test data

toplevel_data_path <- file.path("./alldata" , "UCI HAR Dataset")
filelist<-list.files(toplevel_data_path,  recursive=TRUE)
#filelist

  #load subject data

dataTrainSubject <- read.table(file.path(toplevel_data_path, "train", "subject_train.txt"), header = FALSE)
dataTestSubject  <- read.table(file.path(toplevel_data_path, "test" , "subject_test.txt"),  header = FALSE)

  #load features data

dataTrainFeatures <- read.table(file.path(toplevel_data_path, "train", "X_train.txt"), header = FALSE)
dataTestFeatures  <- read.table(file.path(toplevel_data_path, "test" , "X_test.txt"),  header = FALSE)

  #load activity data

dataTrainActivity <- read.table(file.path(toplevel_data_path, "train", "Y_train.txt"), header = FALSE)
dataTestActivity  <- read.table(file.path(toplevel_data_path, "test" , "Y_test.txt"),  header = FALSE)

  #summarise data  

#head(dataTrainSubject)
#head(dataTestSubject)

  #combine data
  #row bind : row 7352 2947

dataSubject <- rbind(dataTrainSubject, dataTestSubject)
#head(dataSubject)
#nrow(dataSubject)

  #combine data

dataFeatures <- rbind(dataTrainFeatures, dataTestFeatures)
#head(dataFeatures)

  #combine data

dataActivity <- rbind(dataTrainActivity, dataTestActivity)
#head(dataActivity)

  #add column names

names(dataSubject) <- c("Subject")
names(dataActivity) <- c("Activity")

featureLabels  <- read.table(file.path(toplevel_data_path, "features.txt"),  header = FALSE)
#head(featureLabels,100)
names(dataFeatures) <- featureLabels$V2
#head(dataFeatures)

  #col combine data

allData <- cbind(dataFeatures, dataSubject)
allData <- cbind(allData, dataActivity)
#head(allData)

  #filter combined data
  # header like 'mean' AND like 'std'

meanstdfeatureLabels <- featureLabels$V2[grepl("mean\\(\\)|std\\(\\)", featureLabels$V2)]
#head(featureLabels,100)
#head(meanstdfeatureLabels,100)

meanstdfeatureLabelsasStr <- as.character(meanstdfeatureLabels)
requiredlabels<-c(meanstdfeatureLabelsasStr, "Subject", "Activity")

allDataMeanStd <- subset(allData, select=requiredlabels)
#head(allDataMeanStd,100)

  #Add Activity Labels

featureLabels  <- read.table(file.path(toplevel_data_path, "activity_labels.txt"),  header = FALSE)
#head(featureLabels$V2,100)
#head(allDataMeanStd$Activity,100)
#head(allDataMeanStd$Subject,500)

allDataMeanStd$ActivityLabel <- featureLabels$V2[allDataMeanStd$Activity]
#head(allDataMeanStd,200)

  #rename column labes with more meaningful text.

#head(allDataMeanStd,1)

  #Acc =>  Accelerometer Gyro => Gyroscope Mag => Magnitude ^t => Time ^f => Frequency BodyBody => Body
  #Use rename (from RCookbook) - less error prone than 'manual' editing many column names

TheData <- allDataMeanStd
#head(TheData,1)
#head(TheData,200)

names(TheData)<-gsub("Acc", "Accelerometer_", names(TheData))
names(TheData)<-gsub("Gyro", "Gyroscope_", names(TheData))
names(TheData)<-gsub("Mag", "Magnitude_", names(TheData))
names(TheData)<-gsub("Body", "Body_", names(TheData))
names(TheData)<-gsub("BodyBody", "Body_", names(TheData))
names(TheData)<-gsub("Gravity", "Gravity_", names(TheData))
names(TheData)<-gsub("^t", "Time_", names(TheData))
names(TheData)<-gsub("^f", "Frequency_", names(TheData))
names(TheData)<-gsub("-mean()", "Mean", names(TheData))
names(TheData)<-gsub("-std()", "Standard", names(TheData))


  #creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#head(TheData,1)

library(plyr);
library(reshape2);

  #reshape data where Activity(Activity Lbel) and Subject are the same.
AggregatedData <- melt(TheData,id=c("Activity","ActivityLabel","Subject"))
head(AggregatedData,1)

MeanAggregatedData <- dcast(AggregatedData, Activity + ActivityLabel + Subject ~ variable, fun.aggregate = mean, na.rm=TRUE)
#head(MeanAggregatedData,1)

  #produce step5 output
write.table(MeanAggregatedData, file = "tidyDataSet.txt",row.name=FALSE)