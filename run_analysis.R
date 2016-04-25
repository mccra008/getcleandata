## Step 1
# Import all data (remember to set correct wd of getcleandata first)
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# Format data as subjects, labels, all else
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))

## Step 2
# Read features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
# only retain features of mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# Select means and standard deviations from data (only), incrementing
# by two as data has both subjects and labels
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## Step 3
# Read labels (ie activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## Step 4
# Make a list of column and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)
# Tidy that list by removing non-alpha chars and converting to lower case
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# Use the list as col names
colnames(data.mean.std) <- good.colnames

## Step 5
# Calculate means for all subject/label combinations
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

# Write the data to a table for upload
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)
