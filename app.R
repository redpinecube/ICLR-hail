# Load required libraries
library(shiny)
library(leaflet)
library(tidyverse)

library(tidyverse)

# Define the date range
start_date <- as.Date("2024-06-01")
end_date <- as.Date("2024-09-30")
date_range <- seq(start_date, end_date, by = "day")

# Generate 700 random dates within the range
set.seed(123)  # For reproducibility
random_dates <- sample(date_range, size = 700, replace = TRUE)

# Create a tibble with data points for each random date
data <- tibble(
  date = random_dates,
  longitude = runif(700, min = -140, max = -50),  # Random longitudes within Canadian range
  latitude = runif(700, min = 42, max = 85),      # Random latitudes within Canadian range
  size = sample(1:15, 700, replace = TRUE)        # Random size values
)

# Define UI for application
ui <- fluidPage(
  titlePanel("Interactive Map"),
  
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
        color = "blue",
        fillOpacity = 0.7,
        popup = ~paste("Date:", date, "<br>Size:", size)
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


