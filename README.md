#Getting & Cleaning Data: Assignment

This assignment is the [JH: BSPH Course `Getting and Cleaning Data`](https://class.coursera.org/getdata-015).

#Code Book
The code book for the data set can be found [here](CodeBook.md)

#Generating Data

##System Used

  - OSX 10.10, R v3.1.3 (RStudio 0.98.1103)
  - Extra Packages:
      - data.table 1.9.4

##Running Script

**Step 1**: 
Download the data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), and unzip it on your working directory. This should create a directory named `UCI HAR Dataset` . This name is important for the program to run. If you change it, you can modify the `DATADIR` parameter on the script. 
*Note: Alternatively, you can just use the `downloadData` function in the script, and it will take care of that for you.*

**Step 2**: 
Call the `generateTidyDataSet` function. It takes no parameters, and it should generate the summarised, tidy data set to a text file named `tidyDataSet.txt`.
