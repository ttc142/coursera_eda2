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

# find total emission from motor vehicle sources in Baltimore City and LA
NEI_vehicle_compare <- NEI %>%
   group_by(fips,year) %>%
   filter(SCC %in% vehicle$SCC, fips %in% c("06037","24510")) %>%
   summarise(sum(Emissions,na.rm=TRUE))
colnames(NEI_vehicle_compare) <- c("fips", "year", "emission_sum")

NEI_vehicle_compare

# plot
g <- qplot(data=NEI_vehicle_compare, x=year, y=emission_sum) + 
   geom_line(aes(col=fips)) + geom_point(aes(col=fips)) +
   scale_x_continuous(name="Year",breaks=c(1999,2002,2005,2008)) + 
   scale_y_continuous(name="Total PM2.5 Emission")
g <- g + labs(title = "Emissions from motor vehicle sources \nin Baltimore City and Los Angeles County")
g + scale_colour_discrete(name = "Location", labels = c("Los Angeles County", "Baltimore City"))


dev.copy(png,file = "plot6.png")
dev.off()