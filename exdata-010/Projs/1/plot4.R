########################################################################
## 
## R code as part solution to Project 1,
## Coursera course exdata-010
## 
## Author: agarxiv
## 
## The following scripts create Plot 4 of Project 1, and 
## saves to a PNG file, "plot4.png".
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

# Create Plot 4, save to "plot4.png"
png("plot4.png", res=300, width=15, height=15, units="cm")
par(mfrow=c(2,2))
## Sub-plot 1
plot(combined_data$Global_active_power, ylab="Global Active Power", xlab="", type="l", xaxt = "n", yaxt = "n")
axis(side=1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"), las=0)
axis(side=2,cex.axis=0.8)
## Sub-plot 2
plot(combined_data$Voltage, ylab="Voltage", xlab="datetime", type="l", xaxt = "n", yaxt = "n")
axis(side=1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"), las=0)
axis(side=2,cex.axis=0.8)
## Sub-plot 3
y_limits = range(c(0,combined_data$Sub_metering_1))
plot(combined_data$Sub_metering_1, ylab="Energy sub metering", xlab="", type="l", xaxt = "n", yaxt = "n", ylim=y_limits)
par(new = TRUE)
plot(combined_data$Sub_metering_2, ylab="Energy sub metering", xlab="", type="l", xaxt = "n", yaxt = "n", col = "red", ylim=y_limits)
par(new = TRUE)
plot(combined_data$Sub_metering_3, ylab="Energy sub metering", xlab="", type="l", xaxt = "n", yaxt = "n", col = "blue", ylim=y_limits)
axis(side=1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"), las=0)
axis(side=2,cex.axis=0.8)
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), inset=0, cex=0.6, lty=1, bty="n")
## Sub-plot 4
plot(combined_data$Global_reactive_power, ylab="Global_reactive_power",  xlab="datetime", ylim=range(c(0.0, 0.51)), type="l", xaxt = "n", yaxt="n")
axis(side=1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"), las=0)
axis(side=2,cex.axis=0.6)
dev.off()
