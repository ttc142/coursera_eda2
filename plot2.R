# load package
library(dplyr)

# load data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# find total emission in Baltimore city, Maryland by year
NEI <- as_tibble(NEI)
NEI
NEI_baltimore <- NEI %>%
   group_by(year) %>%
   filter(fips == "24510") %>%
   summarise(sum(Emissions,na.rm=TRUE)) %>%
   print
colnames(NEI_baltimore) <- c("year","emission_sum")

# plot
with(NEI_baltimore,barplot(emission_sum, names.arg = year, col = "yellow",
        ylab ="Total PM2.5 emission", xlab = "Year", ylim = c(0,max(emission_sum)+500)))
title(main = "Total PM2.5 emission \n in Baltimore City, Maryland")

dev.copy(png,file = "plot2.png")
dev.off()