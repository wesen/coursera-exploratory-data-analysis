library(tidyverse)

data <- read_delim("data/household_power_consumption.txt",
                   delim=";",
                   col_types=cols(
                     Date = col_date(format = "%d/%m/%Y"),
                     Time = col_time(format = ""),
                     Global_active_power = col_double(),
                     Global_reactive_power = col_double(),
                     Voltage = col_double(),
                     Global_intensity = col_double(),
                     Sub_metering_1 = col_double(),
                     Sub_metering_2 = col_double(),
                     Sub_metering_3 = col_double()
                   ),
                   n_max=1000
                   )
