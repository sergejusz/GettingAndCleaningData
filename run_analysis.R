library(plyr)
# create consolidated data set

xTrainFile="./train/X_train.txt"
yTrainFile="./train/y_train.txt"
xtrain <- read.table(xTrainFile)
ytrain <- read.table(yTrainFile)

# read train data
subjectTrain <- read.table("train/subject_train.txt")

#read test data
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")

xdata <- rbind(xtrain, xtest)

yData <- rbind(ytrain, ytest)

subjectData <- rbind(subjectTrain, subjectTest)


# get the measurements on mean and stdev for each sample
features <- read.table("features.txt")

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
xdata <- xdata[, mean_and_std_features]
names(xdata) <- features[mean_and_std_features, 2]

# Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")

# update values with correct activity names
yData[, 1] <- activities[yData[, 1], 2]

# correct column name
names(yData) <- "activity"

# label data set with variable names
names(subjectData) <- "subject"

allData <- cbind(xdata, yData, subjectData)

# Create a tidy data set
averagesData <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 1:66]))
# save result
write.table(averagesData, "averages_data.txt", row.name=FALSE)