labels <- read.table("activity_labels.txt")
names(labels) <- c("Activity Id", "Activity Name")
features <- read.table("features.txt")
names(features) <- c("Id", "Name")
x_train <- read.table("train/X_train.txt")
names(x_train) <- features$Name
x_test <- read.table("test/X_test.txt")
names(x_test) <- features$Name
y_train <- read.table("train/y_train.txt")
names(y_train) <- c("Activity Id")
y_test <- read.table("test/y_test.txt")
names(y_test) <- c("Activity Id")
subject_train <- read.table("train/subject_train.txt")
names(subject_train) <- c("Subject")
subject_test <- read.table("test/subject_test.txt")
names(subject_test) <- c("Subject")
data <- cbind(rbind(x_train, x_test))
data <- data[, grep(".*mean\\(\\).*|.*std\\(\\).*", features$Name)]
data <- cbind(rbind(merge(y_train, labels)["Activity Name"], merge(y_test, labels)["Activity Name"]), data)
data <- cbind(rbind(subject_train, subject_test), data)
tidy <- data.frame()
for(subject_data in split(data, data$Subject)){
  subject <- subject_data$Subject[1]
  for(activity_data in split(subject_data, subject_data["Activity Name"])){
    if(nrow(activity_data) > 0){
      activity <- activity_data["Activity Name"][[1]][1]
      tidy <- rbind(tidy, cbind(data.frame(subject, activity), rbind(colMeans(activity_data[, 3:68]))))
    }
  }
}
names(tidy) <- names(data)
write.table(tidy, row.name = FALSE, file = "tidy.txt")