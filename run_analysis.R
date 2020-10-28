library(data.table)
library(dplyr)

# reading colname form features
col_name <- fread('D:\\Downloads\\UCI HAR Dataset\\features.txt')

# reading train data and rename colname
x_train <- fread('D:\\Downloads\\UCI HAR Dataset\\train\\X_train.txt', col.names = col_name$V2)
y_train <- fread('D:\\Downloads\\UCI HAR Dataset\\train\\y_train.txt', col.names = 'ID')
sub_train <- fread('D:\\Downloads\\UCI HAR Dataset\\train\\subject_train.txt', col.names = 'subject')

# reading test data and rename colname
x_test <- fread('D:\\Downloads\\UCI HAR Dataset\\test\\X_test.txt',col.names = col_name$V2)
y_test <- fread('D:\\Downloads\\UCI HAR Dataset\\test\\y_test.txt', col.names = 'ID')
sub_test <- fread('D:\\Downloads\\UCI HAR Dataset\\test\\subject_test.txt', col.names = 'subject')

# reading activities
activity <- read.table('D:\\Downloads\\UCI HAR Dataset\\activity_labels.txt', col.names = c('ID','activity'))

# combining train and test data
train <- cbind(y_train, sub_train, x_train)
test <- cbind(y_test,sub_test,x_test)
total <- as.data.frame(rbind(train,test))

# finding mean and std data
columnsToKeep <- grepl("subject|ID|mean|std", colnames(total))
filtered_table <- total[,columnsToKeep]

# merge ID and Activities
merged_table <- merge(filtered_table, activity, by='ID',all.x = TRUE)

# Making a second tidy data set
tidyData <- aggregate(. ~subject +activity , merged_table, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity), ]

# output the tidyData
write.table(tidyData, "D:\\Downloads\\UCI HAR Dataset\\tidyData.txt", row.names = FALSE)