# load package
library(dplyr)
library(ggplot2)

# load data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# find total emission in Baltimore city, Maryland by year
NEI <- as_tibble(NEI)
NEI
NEI_baltimore_type <- NEI %>%
   group_by(type,year) %>%
   filter(fips == "24510") %>%
   summarise(sum(Emissions,na.rm=TRUE)) %>%
   print
colnames(NEI_baltimore_type) <- c("type","year","emission_sum")

# plot
g <- qplot(data=NEI_baltimore_type,x=year, y=emission_sum) 
g <- g + geom_line(aes(col=type)) + scale_x_continuous(name="Year",breaks=c(1999,2002,2005,2008))
g + scale_y_continuous(name="Total PM2.5 Emission", limits = c(0,2500)) + labs(title = "Total PM2.5 Emissions By Source Type", subtitle = "In Baltimore City, Maryland")


dev.copy(png,file = "plot3.png")
dev.off()