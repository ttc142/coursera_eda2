# load package
library(dplyr)
library(ggplot2)

# load data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
NEI <- as_tibble(NEI)
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
SCC <- as_tibble(SCC) 
summary(SCC$EI.Sector)

# find SCC related to coal combustion
vehicle <- SCC %>%
   select(SCC, EI.Sector) %>%
   filter(grepl("Vehicles",EI.Sector)) %>%
   print

# find total emission from motor vehicle source in Baltimore City
NEI_vehicle_baltimore <- NEI %>%
   group_by(year) %>%
   filter(SCC %in% vehicle$SCC, fips=="24510") %>%
   summarise(sum(Emissions,na.rm=TRUE))
colnames(NEI_vehicle_baltimore) <- c("year","emission_sum")

NEI_vehicle_baltimore

# plot
g <- qplot(data=NEI_vehicle_baltimore, x=year, y=emission_sum, geom="line") + geom_point() + 
   scale_x_continuous(name="Year",breaks=c(1999,2002,2005,2008)) + 
   scale_y_continuous(name="Total PM2.5 Emission")
g + labs(title = "Emissions from motor vehicle sources \n in Baltimore City")

dev.copy(png,file = "plot5.png")
dev.off()