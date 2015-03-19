# `run_analysis.R`

`run_analysis.R` is a script for retrieving and cleaning the Galaxy S accelerometer data available at [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  

## Dependencies

`run_analysis.R` uses the `dplyr` package.  If not available at runtime, the dataset will be downloaded automatically.  

## Script Overview

The script performs the following steps:  

1. `dplyr` is loaded.  If necessary, the data are downloaded and unzipped.  The data are downloaded as the file `smartphone_data.zip`, and unzipped to the folder `UCI HAR Dataset`.  

2. A runtime codebook is generated to identify the different activity types.  The activities are labeled as follows:  

	1. walking
	2. walking_upstairs
	3. walking_downstairs
	4. sitting
	5. standing
	6. laying
	
3. Columns in the dataset corresponding to means and standard deviations of dataset features are identified.  These columns are given quasi-human-readable names corresponding to the labels in the file `features_info.txt` (included in the unzipped data folder).  See that file, or `codebook.md` in this repository, for an explanation of the features.  

4. The desired columns are read from the `test` and `train` datasets, along with the activity and research subject for each observation.  All of this is stored in the variable `data`.  

5. Means are calculated for each feature conditional on activity and subject.  All together, means for 66 features are calculated over 180 subject-activity combinations.  These means are stored in the variable `means` and the file `means.txt`.  

NB Column labels are the original feature labels, but the data are *means* for the observations of these features.  For example, the column `tBodyAcc.std.X` in `means` reports the mean (conditional on activity and subject) of the standard deviation of the feature `tBodyAcc` in the X direction.  The columns `activity` and `subject` identify the activity and subject used for each mean.  