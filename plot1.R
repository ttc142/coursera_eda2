library(dplyr)
# read data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
# convert to tibble for easier manipulation
NEI <- as_tibble(NEI)

# calculate total PM2.5 emission by year
NEI_year <- NEI %>%
   group_by(year) %>%
   summarise(sum(Emissions,na.rm=TRUE)) %>%
   print
colnames(NEI_year) <- c("year","emission_sum")

# plot total PM2.5 emission by year
with(NEI_year,barplot(emission_sum, names.arg = year, width= rep(5,4),col = "light blue",
        ylab ="Total PM2.5 emission", xlab = "Year", ylim = c(0,max(emission_sum)+10000)))
title(main = "Total PM2.5 emission from all sources \n by year")

dev.copy(png,file = "plot1.png")
dev.off()