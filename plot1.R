library(data.table)

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

temp <- tempfile()
download.file(data_url, temp, method = "curl")
unzip(temp)
unlink(temp)

data_file <- "household_power_consumption.txt"

data <- fread(data_file, sep = ";", na.strings = "?", colClasses = "character")
unlink(data_file)

data$Date <- as.Date(strptime(data$Date, "%d/%m/%Y"))

sel <- data[(data$Date == "2007-02-01") | (data$Date == "2007-02-02")]

title <- "Global Active Power"
label <- "Global Active Power (kilowatts)"
hist(as.numeric(sel$Global_active_power), col = "red", main = title, xlab = label) 