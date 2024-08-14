# Load the required libraries
library(shiny)
library(leaflet)

# Define UI for application
ui <- fluidPage(
  titlePanel("Interactive Map of Canada"),
  sidebarLayout(
    sidebarPanel(
      # You can add input controls here if needed
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap tiles
      setView(lng = -106.3468, lat = 56.1304, zoom = 4) %>%  # Center the map on Canada
      addMarkers(lng = -106.3468, lat = 56.1304, popup = "Canada")  # Add a marker for Canada
  })
}

# Run the application
shinyApp(ui = ui, server = server)
