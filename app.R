# Load required libraries
library(shiny)
library(leaflet)
library(tidyverse)

# Define the date range
start_date <- as.Date("2024-06-01")
end_date <- as.Date("2024-09-30")
date_range <- seq(start_date, end_date, by = "day")

# Generate 100 random dates within the range
set.seed(123)  # For reproducibility
random_dates <- sample(date_range, size = 150, replace = TRUE)

# Create a tibble with data points for each random date
data_alberta <- tibble(
  date = random_dates[1:70],
  longitude = rnorm(70, mean = -115, sd = 3),# Random longitudes within Canadian range
  latitude = rnorm(70, mean = 55, sd = 3),      # Random latitudes within Canadian range
  size = sample(5:15, 70, replace = TRUE)        # Random size values
)
data_ontario <- tibble(
  date = random_dates[71:85],
  longitude = rnorm(15, mean = -72, sd = 3),# Random longitudes within Canadian range
  latitude = rnorm(15, mean = 50, sd = 3),      # Random latitudes within Canadian range
  size = sample(5:15, 15, replace = TRUE)        # Random size values
)
data_canada <- tibble(
  date = random_dates[86:150],
  longitude = rnorm(65, mean = -100, sd = 6),# Random longitudes within Canadian range
  latitude = rnorm(65, mean = 53, sd = 6),      # Random latitudes within Canadian range
  size = sample(5:15, 65, replace = TRUE)     
) 
data_ontario <- data_ontario %>%
  mutate(image_url = paste0("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6jyYrJHuc4uw6QivUF2wGLeWZirZIbSmqKg&s", size))
data_alberta <- data_alberta %>%
  mutate(image_url = paste0("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyoUo7VVYaVX2l8eo20n8uiViKFtb-R-DQww&s", size))
data_canada <- data_canada %>%
  mutate(image_url = paste0("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTorcu-WnAH_uJyGSc5utF_H6N_lyNMm8UfEw&s", size))

data <- bind_rows(
  mutate(data_alberta, region = "Alberta"),
  mutate(data_ontario, region = "Ontario"),
  mutate(data_canada, region = "Canada")
)

# Define UI for application
ui <- fluidPage(
  titlePanel("Interactive Hail Map"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("dateRange", "Select Date Range:",
                  min = min(data$date), max = max(data$date),
                  value = c(min(data$date), max(data$date)), 
                  timeFormat = "%b %d, %Y", 
                  step = 1, 
                  animate = TRUE)
    ),
    
    mainPanel(
      leafletOutput("map")  # Output for the map
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    # Filter data based on the selected date range
    filtered_data <- data %>%
      filter(date >= input$dateRange[1] & date <= input$dateRange[2])
    
    leaflet(filtered_data) %>%
      addTiles() %>%
      setView(lng = -106.3468, lat = 56.1304, zoom = 4) %>%
      addCircleMarkers(
        ~longitude, ~latitude, 
        radius = sqrt(filtered_data$size),  # Adjust marker size based on 'size'
        color = "red",
        fillOpacity = 0.7,
        popup = ~paste("Date:", date, "<br>Size (cm):", size,"<br><img src='", 
                       image_url, "' width='150' height='150'>")
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


