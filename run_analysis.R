### read in raw data ###

### train data
subject_train = data.table::fread(input = '~/Downloads/UCI HAR Dataset/train/subject_train.txt')

X_train = data.table::fread('~/Downloads/UCI HAR Dataset/train/X_train.txt')
featuresDF = data.table::fread('~/Downloads/UCI HAR Dataset/features.txt')

y_train = data.table::fread('~/Downloads/UCI HAR Dataset/train/y_train.txt')


### test data
subject_test = data.table::fread(input = '~/Downloads/UCI HAR Dataset/test/subject_test.txt')

X_test = data.table::fread('~/Downloads/UCI HAR Dataset/test/X_test.txt')
featuresDF = data.table::fread('~/Downloads/UCI HAR Dataset/features.txt')

y_test = data.table::fread('~/Downloads/UCI HAR Dataset/test/y_test.txt')


activityLabels = data.table::fread('~/Downloads/UCI HAR Dataset/activity_labels.txt')

### load packages
install.packages('tidyverse')
library(tidyverse)

### some data cleaning
colnames(subject_train) = 'subject'
subject_train$subject = as.factor(subject_train$subject)

features = featuresDF$V2
colnames(X_train) = features
colnames(X_test) = features

colnames(y_train) = 'activityId'

colnames(subject_test) = 'subject'
subject_test$subject = as.factor(subject_test$subject)

colnames(y_test) = 'activityId'

colnames(activityLabels) = c('activityId', 'activityLabel')

### merge train and test data
  ### individually first, then together
train = cbind(subject_train, X_train, y_train)
train$set = 'train'

testing = cbind(subject_test, X_test, y_test)
testing$set = 'test'

totalRaw = rbind(train, testing)

### several variable names are repeated
### none are mean or st. dev., so I'm finding and removing them
dupeCols = featuresDF %>% group_by(V2) %>% summarise(n = n()) %>% filter(n > 1) %>% 
  select(V2) %>% rename(dupeCols = V2)
dupeCols = dupeCols$dupeCols
nonDupeCols = setdiff(colnames(totalRaw), dupeCols)
totalDeduped = subset(totalRaw, select = nonDupeCols)

meanCols = colnames(totalDeduped)[grepl(pattern = 'mean()', colnames(totalDeduped), fixed = TRUE)]
stdCols = colnames(totalDeduped)[grepl(pattern = 'std()', colnames(totalDeduped), fixed = TRUE)]
meanStdCols = c(meanCols, stdCols)
keepCols = c('subject', 'activityId',  'set', meanStdCols)

### limit data to mean and st. dev. measurements; join on activity labels
meanStdData = totalDeduped %>% select(match(keepCols,names(.))) %>% 
  left_join(activityLabels) %>% select(-activityId) %>% 
  rename(activity = activityLabel)

### more descriptive column names
colnames(meanStdData) = gsub('^t', 'time_', colnames(meanStdData))
colnames(meanStdData) = gsub('^f', 'FFT_', colnames(meanStdData))
colnames(meanStdData) = gsub('\\(', '', colnames(meanStdData))
colnames(meanStdData) = gsub('\\)', '', colnames(meanStdData))
colnames(meanStdData) = gsub('std', 'StandardDeviation', colnames(meanStdData))
colnames(meanStdData) = gsub('mean', 'Mean', colnames(meanStdData))
colnames(meanStdData) = gsub('Acc', 'Acceleration', colnames(meanStdData))
colnames(meanStdData) = gsub('Mag', 'Magnitude', colnames(meanStdData))
colnames(meanStdData) = gsub('X$', 'X-direction', colnames(meanStdData))
colnames(meanStdData) = gsub('Y$', 'Y-direction', colnames(meanStdData))
colnames(meanStdData) = gsub('Z$', 'Z-direction', colnames(meanStdData))


### create a summary data set from the data set above
summaryData = meanStdData %>% 
  select(-set) %>% 
  group_by(subject, activity) %>% 
  summarise_each(funs(mean))

write.table(summaryData, file = 'tidyData.txt', row.name = FALSE)









