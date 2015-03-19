# `means.txt` Codebook

This document describes the structure of the tidy data file `means.txt` produced by the script `run_analysis.R`.  

Broadly, the data file contains averages (means) of upstream data from a Galaxy S phone accelerometer, grouped by research subject and activity type.  See the file `features_info.txt` in `UCI HAR Dataset` (downloaded and unzipped by `run_analysis.R`) for further details of the upstream data.  The following partial description of the upstream data comes from that file:  

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

## Columns 1-2

`activity`
:
The activity type; one of walking, walking_upstairs, walking_downstairs, sitting, standing, laying.  

`subject`
:
The integer ID of the research subject.  

## Columns 3-68

The labels for these columns have the form `<feature>.<stat>.<XYZ>`, where

`<feature>`
:
The data feature.  One of the following:  

* tBodyAcc
* tGravityAcc
* tBodyAccJerk
* tBodyGyro
* tBodyGyroJerk
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc
* fBodyAccJerk
* fBodyGyro
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

`<stat>`
:
One of `mean` or `std`, the mean or standard deviation.  

`<XYZ>`
:
A direction, one of `X`, `Y`, or `Z`.  

Each entry in these columns is the average (mean) of `<feature>.<stat>.<XYZ>` in the upstream data, for the research subject-activity combination given by the `subject` and `activity` entries.  That is, the data in `means.txt` are means of means or means of standard deviations.  
