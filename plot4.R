# load package
library(dplyr)
library(ggplot2)

# load data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
NEI <- as_tibble(NEI)
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
SCC <- as_tibble(SCC) 


# find SCC related to coal combustion
vehicle <- SCC %>%
   select(SCC, EI.Sector) %>%
   filter(grepl("Coal",EI.Sector)) %>%
   print

# find total emission from coal combustion-related sources 
NEI_coal <- NEI %>%
   group_by(year) %>%
   filter(SCC %in% coal$SCC) %>%
   summarise(sum(Emissions,na.rm=TRUE))
colnames(NEI_coal) <- c("year","emission_sum")

NEI_coal

# plot
g <- qplot(data=NEI_coal,x=year, y=emission_sum, geom="line") + geom_point() + 
   scale_x_continuous(name="Year",breaks=c(1999,2002,2005,2008)) + 
   scale_y_continuous(name="Total PM2.5 Emission",limits=c(200000, 600000))
g + labs(title = "Coal combustion related emission in the U.S")

dev.copy(png,file = "plot4.png")
dev.off()

