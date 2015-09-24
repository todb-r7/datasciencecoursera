# Data Science, Getting and Cleaning Data

This repo now is home to `run_analysis.R`. It's pretty straightforward.
Just source it in RStudio or your favorite R IDE, make sure that the
`dir` variable points to something sensible as a working directory, and
fire it off.

The script is commented to describe what it does, but briefly, it:

  * Downloads the prescribed dataset from Cloudfront
  * Extracts the data
  * Reads it all in
  * Combines the training and test data sets into one dataframe
  * Names all the columns sensibly, per the provided `features_info.txt`
  * Fixes up the `Activity` values, per the provided `activity_labels.txt`
  * Generates a tidy dataset of the means of each variable by each
    activity and subject.

For that last bit, `run_analysis.R` depends on the `dplyr` library from
CRAN, so get that (I'm not sure if it's normal practice to arbitrarily
install libraries from within an R script, as seems a little skeezy). If
you hit errors on the `group_by` call, you'll want to
`install.packages("dplyr")`.

Have fun!

