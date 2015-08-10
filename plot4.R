require(data.table)

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

retrieve_data <- function() {
        temp <- tempfile()
        download.file(data_url, temp, method = "curl")
        unzip(temp)
        unlink(temp)        
}

data_file <- "household_power_consumption.txt"

system.time(headers <- fread(data_file, sep = ";", nrow = 0))

# The "skip" and "nrows" parameters are used to amortize 
# time and memory usage when loading the data from the input 
# file with the "fread()" function.

## Estimated lines to skip from input file (not needed dates)
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

label <- "Global Active Power (kilowatts)"
par("bg" = "transparent")
par("pty" = "s")          ## "s" generates a square plotting region
par("cex" = 0.75)


with(sel, plot(pdate, Sub_metering_1, type = "s", col="black", 
               ylab = "Energy sub metering", xlab =""))
with(sel, points(pdate, Sub_metering_2, type = "s", col="red"))
with(sel, points(pdate, Sub_metering_3, type = "s", col="blue"))
legend("topright", lty = rep(1,3), col = c("black", "red", "blue"), 
       legend = names(sel)[7:9])


dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()