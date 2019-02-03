library(tidyverse)
library(gridExtra)
library(lubridate)
library(ggplot2)

# assume each entry costs 20 bytes
estimate <- 2075259 * 9 * 20

# this would take around 380 MB of memory
readLines("data/household_power_consumption.txt", 4)

data <- read_delim(
  "data/household_power_consumption.txt",
  delim = ";",
  col_types = cols(
    Date = col_date(format="%d/%m/%Y"),
    Time = col_time(format=""),
    Global_active_power = col_double(),
    Global_reactive_power = col_double(),
    Voltage = col_double(),
    Global_intensity = col_double(),
    Sub_metering_1 = col_double(),
    Sub_metering_2 = col_double(),
    Sub_metering_3 = col_double()
  )
) %>%
  filter(Date >= ymd("2007-02-01"), Date <= ymd("2007-02-02")) %>%
  mutate(DateTime  = with_tz(as.POSIXct(Date) + Time, tzone="UTC")) %>%
  identity()

p1 <- ggplot(data) +
  geom_line(aes(x=DateTime, y=Global_active_power)) +
  scale_x_datetime(date_breaks = "1 days",
                   date_labels="%a") +
  ylab("Global Active Power (kilowatts)") +
  theme(axis.title.x = element_blank())

p2 <- ggplot(data) +
  geom_line(aes(x=DateTime, y=Voltage)) +
  scale_x_datetime(date_breaks = "1 days",
                   date_labels="%a") +
  ylab("Voltage") +
  theme(axis.title.x = element_blank())

p3 <- data %>%
  select(DateTime, starts_with("Sub_")) %>%
  gather(key, value, -DateTime) %>%
  ggplot(aes(x=DateTime, y=value, colour=key)) +
  geom_line() +
  ylab("Energy sub metering") +
  scale_x_datetime(date_breaks = "1 days",
                   date_labels="%a") +
  theme(legend.position = "top")

p4 <- ggplot(data) +
  geom_line(aes(x=DateTime, y=Global_reactive_power)) +
  scale_x_datetime(date_breaks = "1 days",
                   date_labels="%a") +
  ylab("Global reactive power") +
  theme(axis.title.x = element_blank())


arrangeGrob(p1, p2, p3, p4, nrow=2)

ggsave(file="plot4.png", device="png", width=480/72, height=480/72, units="in", dpi=72)
