require(data.table)

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

retrieve_data <- function() {
        temp <- tempfile()
        download.file(data_url, temp, method = "curl")
        unzip(temp)
        unlink(temp)        
}

## retrieve_data()

data_file <- "household_power_consumption.txt"

system.time(headers <- fread(data_file, sep = ";", nrow = 0))

# The "skip" and "nrows" parameters are used to amortize 
# time and memory usage when loading the data from the input 
# file with the "fread()" function.

## Estimated lines to skip from input file (no needed dates)
skip <- 65000 
## Estimated lines to read from input file
nrows <- 5000

system.time(data <- fread(data_file, sep = ";", na.strings = "?", colClasses = "character", 
                          skip = skip, nrows = nrows))
# unlink(data_file)

setnames(data, names(headers))

data[ , pdate := as.POSIXct(strptime(paste(data$Date, data$Time), 
                                     "%d/%m/%Y %H:%M:%S"))]
setkey(data, pdate)

start <- as.POSIXct("2007-02-01")
end <- as.POSIXct("2007-02-03")

sel <- data[(data$pdate >= start) & (data$pdate < end)]
sel$Global_active_power <- as.numeric(sel$Global_active_power)

## Plot
.pardefault <- par(no.readonly = TRUE)

png(file = "plot2.png", width = 480, height = 480)
title <- "Global Active Power"
label <- paste(title, "(kilowatts)")
with (sel, plot(pdate, Global_active_power, type = 's', ylab = label, xlab = ""))

dev.off()
par(.pardefault)