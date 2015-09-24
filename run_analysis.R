# Clear the environment, set the working directory
rm(list = ls())
home_dir = Sys.getenv('HOMEPATH')
proj_dir = 'Documents/R/project/cleaning-data'
dir = paste(home_dir, proj_dir, sep='/')
setwd(dir)

# Get the data
data_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dest_file = 'dataset.zip'
if (!file.exists(dest_file)) {
  print('Fetching data')
  download.file(data_url, 'dataset.zip')  
} else {
  print('Data already downloaded')
}

# Unzip it, switch to the unzipped directory.
if (!file.exists('UCI HAR Dataset')) {
  print('Extracting data')
  unzip(dest_file)
} else {
  print('Data already extracted')
}
data_dir = paste(dir,'UCI HAR Dataset', sep='/')
setwd(data_dir)

# Read in all the data.
# Test has 2947 records, train has 7352.
print('Reading test tables')
test_subject_table = read.table('test/subject_test.txt')
test_x_table =       read.table('test/X_test.txt')
test_y_table =       read.table('test/y_test.txt')

print('Reading train tables')
train_subject_table = read.table('train/subject_train.txt')
train_x_table =       read.table('train/X_train.txt')
train_y_table =       read.table('train/y_train.txt')

print('Combining test and train data')
column_subject = rbind(test_subject_table,train_subject_table)
column_observations = rbind(test_x_table, train_x_table)
column_activity = rbind(test_y_table,train_y_table)

print('Naming columns')
# The feature table is merely a list of feature names in the second column,
# sequentially, so just grab the second column.
feature_names = read.table('features.txt')[ ,2]

colnames(column_subject) = 'Subject'
colnames(column_activity) = 'Activity'
colnames(column_observations) = feature_names

# Reduce the observation data to just the mean and std readings
observations_sought = grep('mean|std', colnames(column_observations), ignore.case = TRUE)
reduced_observations = column_observations[c(observations_sought)]

print('Creating dataframe of subject, activity, and observations')
df = cbind(column_subject, column_activity)
df = cbind(df, reduced_observations)

print('Replacing variable names and values with human-readable versions')

# Replace the variable names with something more human-readable, as described
# in features_info.txt.

# Just un-shorten the variable names.
names(df) = gsub('^t', 'Time', names(df))
names(df) = gsub('^f', 'Frequency', names(df))
names(df) = gsub('Acc', 'Acceleration', names(df))
names(df) = gsub('Mag', 'Magnitude', names(df))
names(df) = gsub('-X$', '-XAxis', names(df))
names(df) = gsub('-Y$', '-YAxis', names(df))
names(df) = gsub('-Z$', '-ZAxis', names(df))

# Replace the numeric data for 'activity' with the correct mapping from the
# activity labels.
label_list = as.vector(read.table('activity_labels.txt')[,2])
label_names = read.table('activity_labels.txt')[,2]
for (i in 1:6) {
  df$Activity = gsub(i,label_names[i], df$Activity)
}

# Now, create a new tidy dataset, using the fantastically easy to use
# dplyr library.
library(dplyr)
tidy_df = df %>%
  group_by(Activity, Subject) %>%
  summarize_each(funs(mean))

outfile_name = paste(getwd(),'tidy-data-set.txt', sep='/')
write.table(tidy_df, file=outfile_name, row.name=FALSE)

print(paste('All done! Wrote tidy dataset to', outfile_name))

