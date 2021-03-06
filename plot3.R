#Initialize the libraries needed to run the script
library(data.table)
library(dplyr)
library(plyr)

#initialize the url and the zip filename
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fname_zip <- "epc.zip"
fname <- "household_power_consumption.txt"

## Download and unzip the dataset:
if (!file.exists(fname_zip)){
  download.file(url, fname_zip)
}

if (!file.exists(fname)) { 
  unzip(fname_zip) 
}

#Read data into memory and named it hpc excluding "?" and classifying the columns
hpc <- fread(fname, na.strings = "?", colClasses = c(Global_active_power = "numeric", Global_reactive_power = "numeric", 
                                                     Voltage = "numeric", Global_intensity = "numeric", Sub_metering_1 = "numeric",
                                                     Sub_metering_2 = "numeric", Sub_metering_3 = "numeric"))

#subset of the data to only show Feb 1st-2nd 2007 corrisponding rows
sub_hpc <- filter(hpc, Date == "1/2/2007" | Date == "2/2/2007")

#Combining the date and time columns and put into a vector named dt
dt <- strptime(paste(sub_hpc$Date, sub_hpc$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

#piping to add dt to the table and arranging the columns in an appropriate  order excluding the original Date and Time columns
main_sub_hpc <- sub_hpc %>% mutate(Date_Time = dt) %>% select(Date_Time,Global_active_power:Sub_metering_3)

#initializing the plot file and creating the plot
png("plot3.png", width=480, height=480)
plot(main_sub_hpc$Date_Time, main_sub_hpc$Sub_metering_1, type="l", xlab="", ylab="Energy Submetering")
lines(main_sub_hpc$Date_Time, main_sub_hpc$Sub_metering_2, type="l", col = "red")
lines(main_sub_hpc$Date_Time, main_sub_hpc$Sub_metering_3, type="l", col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),lty=1, col=c("black", "red", "blue"))
dev.off()