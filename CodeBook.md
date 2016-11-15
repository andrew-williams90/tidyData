#CodeBook
## Getting and Cleaning Data Course Final Project

### Original Data
* sensor data collected by a smart phone
* n = 30 volunteers wearing the aforementioned smart phone
* types of measurements:
  * linear acceleration
  * angular velocity
  * three-dimensional magnitude
  * Fast Fourier Transform
* an activity label showing the activity that generated the feature set

### Running the Script
* requires that the following data sets are read in from your working directory:
 * X_train
 * y_train
 * X_test
 * y_test
 * subject_train
 * subject_test
 * activity_labels
* script should run from that point on 

### First Tidy Data Set
* Merged both train and test sets
* Limited the data to only mean and standard deviation measurements, per the assignment's instructions
* renamed the columns to be more easily readable / descriptive

### Second Tidy Data Set
* Summarizing the tidy raw data set w/ a mean for each unique combination of subject and activity
* write the table to a .txt file
