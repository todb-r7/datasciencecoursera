# Code Book for UCI HAR Dataset

**TODO: Most of this**

This code book describes the variables, data, and transformations that were performed on the Human Activity Recognition Using Smartphones Dataset, downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Careful readers of this code book should be able to both understand the raw data and replicate the processes used to transform the data for the final tidy data set.

## Upstream provided documentation

The Human Activity Recognition Using Smartphones Dataset comes with ample documentation that describes the initial state of the data as provided. The most significant documentation is:

  * README.txt : An index of all the files provided in the zip archive, a brief description of each, and the license terms of the data set.
  * features_info.txt : Describes the naming conventions for all the measurements observed, and how to decode them.
  * activity_labels.txt: Maps the activity codes to a proper English name
  * features.txt : A list of all the measurements captured.

## Script: run_analysis.R

`run_analysis.R` performs all the neccessary retrieval, extraction, and transformations on the given dataset. It does have one non-standard library dependency, `dplyr`, used to create the final tidy dataset. Also note that this script has been only tested on a Windows platform, so minor changes to the workding directory pathname are likely required for other operating systems.

## Transformations

The original dataset is transformed into a smaller, tidy dataset, unsurprisingly named `tidy-data-set.txt`. It does this by combining all the test and training data into one dataframe, with columns for the human `Subject`being monitored, the `Activity` being performed, and several measurements pulled from a smartphone's accelerometer and gyroscope.

### Truncated data

The only variables we are concerned with for the final tidy dataset are the ones having to do with mean values (`mean`) and standard deviation values (`std`). All the other measurements are discarded.

### Variable name renaming

Per the provided `features_info.txt`, the given variable names are expanded and made somewhat more human-readable, per the table below:

| Name pattern | Expanded |
|--------------|----------|
| Starts with 't' | 'Time' |
| Starts with 'f' | 'Frequency' |
| 'Acc' | 'Acceleration' |
| 'Mag' | 'Magnitude' |
| Ends with 'X' | 'XAxis' |
| Ends with 'Y' | 'YAxis' |
| Ends with 'Z' | 'ZAxis' |

### Variable value renaming

The `activity_labels.txt` describes the relationship between the original, numeric value for an Activity, and the analysis script makes those substituions, as below:

| Integer | English |
|---------|---------|
|1 | WALKING |
|2 | WALKING_UPSTAIRS |
|3 | WALKING_DOWNSTAIRS |
|4 | SITTING |
|5 |STANDING |
|6 | LAYING |

### Newly derived data

The resultant `tidy-data-set.txt` recharacterizes the given data as the mean average per human subject, per activity, using `dplyr`'s `group_by()` and `summarize_each()` functions.
