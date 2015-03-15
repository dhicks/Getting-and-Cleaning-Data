# Desiderata: 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load libraries
library(dplyr)

#setwd('~/Google Drive/Coding/data science/Getting and Cleaning Data')
starting_wd <- getwd()
# Download data
filename <- 'smartphone_data.zip'
if (!file.exists(filename)) {
	download.file(
		url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)',
		destfile = filename,
		method = 'curl'
	)
}
# Unzip data
unzipped_foldername <- 'UCI HAR Dataset'
if (!file.exists(unzipped_foldername)) {
	unzip(filename, overwrite=FALSE)
}
# Move down into the unzipped folder so that paths are shorter
setwd(unzipped_foldername)

# Build codebook for activity types
activity_codebook_filename <- 'activity_labels.txt'
activity_codebook <- read.table(activity_codebook_filename, 
                                colClasses = c('character', 'character'))
activity_codebook <- factor(activity_codebook$V1, labels=activity_codebook$V2)
levels(activity_codebook) <- tolower(levels(activity_codebook))

# Identify the relevant columns to read from the data files:
# Search features.txt for lines with 'mean' or 'std'
features_codebook <- read.table('features.txt')
# The total number of columns in the X_*.txt files
total_cols <- nrow(features_codebook)
features_codebook <- features_codebook %>% 
    # Filter down to only the 'mean' and 'std' features
    # But skip 'meanFreq' features
    filter(grepl('mean[^F]|std', V2)) %>%
    # Give the columns meaningful names
	transmute(column = V1, label = V2) %>%
    # Remove parentheses
    mutate(label = gsub('\\(\\)', '', label)) %>%
    # Replace the dashes with periods
    mutate(label = gsub('-', '.', label))

# features_codebook$column indicates the desired columns in the 
# X_*.txt files

# Build the character vector for colClasses
# Start with everything 'NULL'
read_cols <- rep('NULL', total_cols)
# Add 'numeric' for the columns that we want to read
read_cols[features_codebook$column] <- 'numeric'

# Initialize empty dataset
# Note that this creates a row of 0s at the top
data <- as.data.frame(matrix(rep(0, length(features_codebook$label)), nrow=1))
# Apply the meaningful column labels
names(data) <- features_codebook$label
# For both test and train:
subdatasets = c('test', 'train')
for (subdata in subdatasets) {
	# Construct filename
	data_filename <- paste(subdata, '/X_', subdata, '.txt', sep='')
	# Read desired columns from the file
	readdata <- read.table(data_filename, colClasses = read_cols)
	# Give columns descriptive names
	names(readdata) <- features_codebook$label
    # Read subject IDs from subject_*.txt
    subject_filename <- paste(subdata, '/subject_', subdata, '.txt', sep='')
    subject_data <- read.table(subject_filename, colClasses = c('integer'))
	names(subject_data) <- 'subject'
    readdata <- bind_cols(subject_data, readdata)
	# Read activity IDs from y_*.txt
    activity_filename <- paste(subdata, '/y_', subdata, '.txt', sep='')
    activity_data <- read.table(activity_filename, colClasses = c('character'))$V1
    # Convert to a factor using the levels built from activity_labels.txt
    activity_data <- factor(activity_data, labels=levels(activity_codebook))
    readdata <- data.frame(activity = activity_data) %>% bind_cols(readdata)
    # Attach everything to the bottom of the permanent dataset
	data <- bind_rows(data, readdata)
	# Discard the working datasets
	rm(readdata, subject_data, activity_data)
}
# Slice the extra row of 0s off the top
data <- slice(data, 2:n())

# Group by activity and subject and calculate averages
means <- data %>%
    group_by(activity, subject) %>%
    arrange(subject) %>%
    summarise_each(funs(mean))
# Move back up to the original working directory and write means to disk
setwd(starting_wd)
write.table(means, file = 'means.txt', row.names=FALSE)
