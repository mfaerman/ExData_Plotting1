library(data.table)

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

temp <- tempfile()
download.file(data_url, temp, method = "curl")
unzip(temp)
unlink(temp)

data_file <- "household_power_consumption.txt"

headers <- fread(data_file, sep = ";", nrow = 0)

## Used to amortize time and memory usage 
## Estimated lines to skip from input file (no needed dates)
skip <- 65000 
## Estimated lines to read from input file
nrows <- 5000

data <- fread(data_file, sep = ";", na.strings = "?", colClasses = "character", 
              skip = skip, nrows = nrows)
unlink(data_file)

setnames(data, names(headers))

##data$Date <- as.Date(strptime(data$Date, "%d/%m/%Y"))
d <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
d <- as.POSIXct(d)

start <- as.POSIXct("2007-02-01 00:00:00")
end <- as.POSIXct("2007-02-02 23:59:59")
dsel <- d[(d >= start) & (d <= end)]
sel <- data[(d >= start) & (d <= end)]


label <- "Global Active Power (kilowatts)"

sel$Global_active_power <- as.numeric(sel$Global_active_power)


par("bg" = "transparent")


plot(dsel, sel$Sub_metering_1, type = "s", col="black", ylab = "Energy sub metering")
points(dsel, sel$Sub_metering_2, type = "s", col="red")
points(dsel, sel$Sub_metering_3, type = "s", col="blue")
legend("topright", lty = c(1,1,1), col = c("black", "red", "blue"), legend = names(sel)[7:9])


dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()