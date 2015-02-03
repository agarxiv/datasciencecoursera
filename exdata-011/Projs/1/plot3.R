########################################################################
## 
## R code as part solution to Project 1,
## Coursera course exdata-011
## 
## Author: agarxiv
## 
## The following scripts create Plot 3 of Project 1, and 
## saves to a PNG file, "plot3.png".
## 
## To run this code:
## (1) Make sure data file "household_power_consumption.txt"
##     is placed in the directory containing this script.
## (2) Make sure you have downloaded the R package sqldf.
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

# Create Plot 3, save to "plot3.png"
png("plot3.png", res=300, width=12, height=12, units="cm")
y_limits = range(c(0,combined_data$Sub_metering_1))
plot(combined_data$Sub_metering_1, ylab="Energy sub metering", type="l", xaxt = "n", ylim=y_limits)
par(new = TRUE)
plot(combined_data$Sub_metering_2, ylab="Energy sub metering", type="l", xaxt = "n", col = "red", ylim=y_limits)
par(new = TRUE)
plot(combined_data$Sub_metering_3, ylab="Energy sub metering", type="l", xaxt = "n", col = "blue", ylim=y_limits)
axis(side=1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"), las=0)
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), inset=0, cex=1, lty=1)
dev.off()
