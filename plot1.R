library(data.table)

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

temp <- tempfile()
download.file(data_url, temp, method = "curl")
unzip(temp)
unlink(temp)

data_file <- "household_power_consumption.txt"

headers <- fread(data_file, sep = ";", nrow = 0)

## Used to amortize reading time and memory usage 
## Estimated lines to skip from input file (no needed dates)
skip <- 65000 
## Estimated lines to read from input file
nrows <- 5000

data <- fread(data_file, sep = ";", na.strings = "?", colClasses = "character", 
              skip = skip, nrows = nrows)
unlink(data_file)

setnames(data, names(headers))

data$Date <- as.Date(strptime(data$Date, "%d/%m/%Y"))

sel <- data[(data$Date == "2007-02-01") | (data$Date == "2007-02-02")]

title <- "Global Active Power"
label <- "Global Active Power (kilowatts)"

sel$Global_active_power <- as.numeric(sel$Global_active_power)


par("bg" = "transparent")
hist(sel$Global_active_power, col = "red", main = title, xlab = label)

dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()