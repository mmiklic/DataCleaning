##### Short instructions for running the run_analysis.R script.

The script uses 'dplyr' and 'reshape2' packages. Please make sure those packages are
installed in your environment before sourcing the script.

The run_analysis.R script includes two functions:

**downloadUnzip()** - this function downloads and unzips the required dataset. 
                  It also sets the working directory to "./data_cleaning_course" to
                  avoid having Samsung data in the main directory.
                  Only run this function if you have not already downloaded this data.
                  
**extractWrite()** - assumes that the data was downloaded already to "./UCI HAR Dataset/"
                 folder either with the previous function or manually. Writes the
                 tidy data set into "tidy_set.txt".


