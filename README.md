# Getting-and-Cleaning-Data-Course-Project
This repo contains deliverables for Getting and Cleaning Data Course Project

This is the course project for Getting and Cleaning Data. 

This project includes these deliverables:
* `run_analysis.R` containes the R code to process the raw dataset to tidy dataset
* `CodeBook.md` describes the variables, data that `run_analysis.R` performed to clean up the data.
* `README.md` describes how all of the scripts work and how they are connected.
* `tidy_data.txt` contains the processed tidy dataset for analysis

`run_analysis.R` does the following tasks:
* Check if the zipped dataset "UCI HAR Dataset" exists in the working directory and download then unzip the dataset if not exist. This task is performed by 
```
if (!file.exists("UCI HAR Dataset")) {
    download.file(fileURL, fileName, method = "curl")
    unzip(fileName)
}    
```
* install and load `dplyr` and `reshape2` package
* Merge training and test dataset into one single dataset, combined with `Subject` and `Activity` data
* Extract only the mean and standard deviation measurements for each variable.
* Link activity names and descriptive variable names to the dataset.
* Reconstruct the dataset by creating a new dataset with the average of each variable for each activity and subject.
I used `melt()` and `dcast()` from `reshape2` package
* Output tidy data to `tidy_data.txt`
