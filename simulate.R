#### Simulate Hail Data For Canadian Locations. 
library(tidyverse)
set.seed(123)

### Simulate the following columns:
## Date
## Longitude
## Latitude
## Size (Mean of 6cm)

num_observations <- 700

# Simulate Dates From June 2023 to September 2023
start_date <- as.Date("2023-06-01")
end_date <- as.Date("2024-09-30")
date_sequence <- seq.Date(start_date, end_date, by = "day")
date <- sample(date_sequence, num_observations, replace = TRUE)

# Simulate Location for Canada
longitude = runif(122, min = -140, max = -50)
latitude = runif(num_observations, min = 42, max = 85)
# Simulate Hail Size
mean_value <- 7.5
sd_value <- 6
size <- rnorm(num_observations, mean = mean_value, sd = sd_value)

hail_dataframe <- data.frame(date, longitude, latitude, size)
write_csv(hail_dataframe, "data.csv")
