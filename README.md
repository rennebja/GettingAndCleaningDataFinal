# GettingAndCleaningDataFinal

Included files:
* GaCD-tidied_data.txt - a text file output of the tidied data from the run_analysis.R script
* README.md - this README file listing repo contents and the function of the script
* run_analysis.R - gets and cleans a specific set of data from the UCI HAR project

The run_analysis.R script is my final project for the Johns Hopkins Coursera course Getting And Cleaning Data.

The script retrieves a set of human activity data from UC Irvine that was collected using smartphone sensors.
It, then, decompresses that data, reads them in across a few steps:
  1. Combine the activity values in the training and test sets by appending the latter to the former in a dataframe
  2. Add descriptive activity names to the combined activity data by matching on indices
  3. Combine the measured values in the training and test sets by appending the latter to the former in a separate dataframe named "my_data"
  4. Add the descriptive activity names as a new column to my_data
  5. Add subject identification numbers as a new column to my_data
  6. Keeps only the values reporting mean and standard deviation

The feature labels as provided refer to multiple variables, so to tidy up the data the script:
  1. Gathers the feature labels into a column
  2. Separates those feature labels into three parts
  3. Spreads the type of measure back across three columns: mean, meanFreq, and std

It then summarizes the three measures by mean, resulting in the "tidied_data" dataframe with the following configuration
  1. subject - Numeric field indicating the subject from which the measurements were taken
  2. activity - Character field containing a descriptive name identifying the activity the subject was performing at the time of measure
  3. measure - Character field containing the type of measurement recorded
  4. axis - Character field identifying the axis on which a particular type of measure was recorded. Measures of magnitude have had their axis marked "Not Applicable"
  5. AvgMean - Numeric field containing the average of all values for the mean of a particular measure along a particular axis
    + e.g. the average of all measures of fBodyAcc along the X axis for subject 1 while standing
  6. AvgMeanFreq - Numeric field containing the average of all values for the meanFreq of a particular measure along a particular axis
  7. AvgStd - Numeric field containing the average of all values for the mean of a particular measure along a particular axis
