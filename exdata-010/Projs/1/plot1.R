########################################################################
## 
## R code as part solution to Project 1,
## Coursera course exdata-008
## 
## Author: agarxiv
## 
## The following scripts create Plot 1 of Project 1, and 
## saves to a PNG file, "plot1.png".
## 
## To run this code:
## (1) Make sure data file "household_power_consumption.txt"
##     is placed in the directory containing this script.
## (2) Make sure you have downloaded the R package sqldf.
## 
## 
########################################################################

library(sqldf)

# Some initial variables
infile = "household_power_consumption.txt"
sql_pat1 = 'select * from file where Date=="1/2/2007"'
sql_pat2 = 'select * from file where Date=="2/2/2007"'

# Extract data from data file
data_set1 <- read.csv.sql(infile, sep=";", sql=sql_pat1)
data_set2 <- read.csv.sql(infile, sep=";", sql=sql_pat2)
combined_data <- rbind(sub1, sub2)

# Create Plot 1, save to "plot1.png"
png("plot1.png", res=300, width=10, height=10, units="cm")
hist(combined_data$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()
