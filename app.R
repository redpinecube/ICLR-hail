# Load required libraries
library(shiny)
library(leaflet)
library(tidyverse)

# Define the date range
start_date <- as.Date("2024-06-01")
end_date <- as.Date("2024-09-30")
date_range <- seq(start_date, end_date, by = "day")

# Generate 700 random dates within the range
set.seed(123)  # For reproducibility
random_dates <- sample(date_range, size = 100, replace = TRUE)

# Create a tibble with data points for each random date
data <- tibble(
  date = random_dates,
  longitude = rnorm(100, mean = -115, sd = 2),# Random longitudes within Canadian range
  latitude = rnorm(100, mean = 55, sd = 2),      # Random latitudes within Canadian range
  size = sample(5:15, 100, replace = TRUE)        # Random size values
)

data <- data %>%
  mutate(image_url = paste0("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyoUo7VVYaVX2l8eo20n8uiViKFtb-R-DQww&s", size))

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
        popup = ~paste("Date:", date, "<br>Size:", size,"<br><img src='", 
                       image_url, "' width='150' height='150'>")
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


