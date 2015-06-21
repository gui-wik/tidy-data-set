# base data folder: UCI HAR Dataset (should on same folder as script)
# datafile: file.path(datatir, filename)
DATADIR <- "UCI HAR Dataset"
TEST <- "test"
TRAIN <- "train"

SUBJECT_PREFIX <- "subject_"
DATA_PREFIX <- "X_"
ACTIVITY_PREFIX <- "y_"

downloadData <- function(){
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    archivefile = paste(DATADIR, ".zip")
    
    download.file(url=url, destfile=archivefile, method="curl")
    
    unzip(zipfile=archivefile)
}

loadData <- function(dataGroup){
    
    # Loads all data variables (features, subject, and activity) for either training of testing data
    # Used by generateTidyDataSet
    
    if (! dataGroup %in% c(TRAIN, TEST)){
        stop("dataGroup must be either 'train' or 'test'")
    }
    
    # load labels
    fp = file.path(DATADIR, "activity_labels.txt")
    print(sprintf("loading activity labels from @'%s'", fp))
    labels= read.table(fp, 
                       sep=" ", 
                       col.names=c("id", "label"), 
                       fill=FALSE, 
                       strip.white=TRUE)
    
    # load features 
    fp = file.path(DATADIR, "features.txt")
    print(sprintf("loading features from @'%s'", fp))
    features = read.table(fp, 
                       sep=" ", 
                       col.names=c("id", "feature"), 
                       fill=FALSE, 
                       strip.white=TRUE)
    features[, "feature"] <- make.names(features[,"feature"])

    # load activities
    fp = file.path(DATADIR, dataGroup, paste(ACTIVITY_PREFIX, dataGroup, ".txt", sep=""))
    print(sprintf("loading activities from @'%s'", fp))
    activities = read.table(fp,
                            col.names=("id"),
                            fill=FALSE,
                            strip.white=TRUE)

    # load subjects
    fp = file.path(DATADIR, dataGroup, paste(SUBJECT_PREFIX, dataGroup, ".txt", sep=""))
    print(sprintf("loading subjects from @'%s'", fp))
    subjects = read.table(fp,
                          col.names=("id"),
                          fill=FALSE,
                          strip.white=TRUE)
    
    # load features
    # this takes a while. fread in data.table 1.9.4 seems to have a bug
    # when reading numeric data from txt files with space delimeters
    fp = file.path(DATADIR, dataGroup, paste(DATA_PREFIX, dataGroup, ".txt", sep=""))
    print(sprintf("loading records from @'%s'", fp))
    records = read.table(fp,
                         col.names=(features[,"feature"]),
                         fill=TRUE,
                         strip.white=TRUE,
                         nrows=7352,
                         stringsAsFactors=FALSE
            )

    #activities
    records["subject"] <- subjects
    records["activity"] <- factor(activities[,"id"], labels=labels[,"label"])

    records
}

generateTidyDataSet <- function() {
    
    # generates a tidy data set by merging, and aggregating training and testing data sets
    
    library(data.table)

    trainingSet <- loadData('train')
    testSet <- loadData('test')
    
    dataSet <- rbind(trainingSet, testSet)
    
    #filter columns (means and stdevs only + identifiers)
    columns <- colnames(dataSet)
    keys <- c("mean", "std", "subject", "activity")
    validColumns <- sapply(columns, function(colname){ any(sapply(keys, function(key){ grepl(key, colname)})) })
    trimmedSet <- data.table(dataSet[, validColumns])

    #return trimmed data set
    tidyDataSet <- aggregate(. ~ activity + subject, trimmedSet, mean)
    
    write.table(tidyDataSet, file="tidyDataSet.txt", row.name=FALSE, fileEncoding="UTF-8")
}

