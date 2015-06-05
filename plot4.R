# plot4.R
#
# The goal of this study is examining how household energy usage varies over a 
# 2-day period in February, 2007 . This script corresponds to the project for 
# the Coursera course: Exploratory Data Analaysis


# 1) Load packages:

library(lubridate)


# 2) Determine which rows must be read from the data file:

# The first observation of the variables included in the data file is read,  
# keeping in mind that in this dataset missing values are coded as ?:

filename <- "household_power_consumption.txt"

data <- read.csv(filename, header = TRUE, sep = ";", na.strings = "?", 
                 nrows = 1, stringsAsFactors = FALSE)

# The date with time of the first observation included in the data file is:

daytimefirsfiletrow <-paste(data$Date[1], data$Time[1], sep = " ", 
                            collapse = NULL)
daytimefirsfiletrow <- strptime(daytimefirsfiletrow,"%d/%m/%Y %H:%M:%S")

# Only data from the dates 2007-02-01 and 2007-02-02 will be used, so - 
# considering the format of the date and time variables in the dataset - the 
# date with time of the first observation to be read is:

daytimefirstdatarow <- strptime("01-02-2007 00:00:00", "%d-%m-%Y %H:%M:%S") 

# And the date with time of the last observation to be read is:

daytimelastdatarow <- strptime("02-02-2007 23:59:00", "%d-%m-%Y %H:%M:%S") 

# So - keeping in mind that the dataset contains "measurements of electric power 
# consumption in one household with a ONE-MINUTE SAMPLING RATE" - the number of 
# lines of the data file to skip before begining to read data is:

numrowstoskip <- as.numeric(difftime(daytimefirstdatarow, daytimefirsfiletrow, 
                            units = "mins"))

# and the number of rows to read in is:

numrowstoreadin <- as.numeric(difftime(daytimelastdatarow, daytimefirstdatarow, 
                              units = "mins")) + 1


# 3) Read the data from the dates 2007-02-01 and 2007-02-02 that will be used to
# construct the plots:

epcdata <- read.csv(filename, sep = ";", na.strings = "?",
                    colClasses = c("character", "character", "numeric", 
                                   "numeric", "numeric", "NULL", "numeric", 
                                   "numeric", "numeric"), 
                    nrows = numrowstoreadin, skip = numrowstoskip)

colnames(epcdata) <- names(data)[-6]

# Remove objects from the global environment:

rm(filename, data, daytimefirsfiletrow, daytimefirstdatarow, daytimelastdatarow, 
   numrowstoskip, numrowstoreadin)


# 4) Construct plot 4:

# Open PNG device:

png(file = "plot4.png", width = 480, height = 480) 

# Specify the layout of multiple graphs in one graphing device by setting 
# mfcol equals to c(2,2). Thus, four plots will be combined into one overall 
# graph: They will be arranged in a matrix of 2 rows and 2 columns that will be
# filled in by column:

par(mfcol = c(2,2))

# Create the date with time stamp for each observartion:

datetime <- strptime(paste(epcdata$Date, epcdata$Time, sep = " ", collapse = NULL), 
                     "%d/%m/%Y %H:%M:%S")

# Create the first plot and send to the file:

with(epcdata, plot(datetime, Global_active_power, type = "l", xlab = "",
                   ylab = "Global Active Power"))

# Create the second plot and send to the file:

# Plot Sub_metering_1:

plot(datetime, epcdata$Sub_metering_1, type = "l", xlab = "", 
     ylab = "Energy sub metering")

# Add Sub_metering_2 to the previous plot:

lines(datetime, epcdata$Sub_metering_2, type = "l", col = "red")

# Add Sub_metering_3 to the previous plot:

lines(datetime, epcdata$Sub_metering_3, type = "l", col = "blue")

# Add a legend to the plot:

legend("topright", inset = 0.01, legend = c("Sub_metering_1", "Sub_metering_2", 
                                            "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = c(1,1), cex = 0.9, box.lty = 0)              

# Create the third plot and send to the file:

with(epcdata, plot(datetime, Voltage, type = "l"))

# Create the fourth plot and send to the file:

with(epcdata, plot(datetime, Global_reactive_power, type = "l"))

# Remove objects from the global environment:

rm(epcdata, datetime)

# Close the PNG file device:

dev.off() 