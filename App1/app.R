##############################  
#### Shiny User interface ####
##############################

# Load packages ----

require(shiny)


# Shiny server

server <- function(input, output) {
  output$plothist <- renderPlot({
    hist(x = iris$Sepal.Length, 
         col = input$fillcol, 
         border = input$bordercol, 
         breaks = input$nbbins,
          
         main = "Distribution de la longueur des sépales",
         xlab = "Longueur des sépales",
         ylab = "Fréquence")
  })
}

# Shiny ui ----

ui <- fluidPage(
  # Application title
  titlePanel("Avec shiny, personnalise ton histogramme !"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "fillcol", label = "Choisis la couleur de remplissage", 
                  selectize = TRUE, multiple = FALSE,
                  choices = c("black", "grey", "blue", "orange", "red")),
      selectInput(inputId = "bordercol", label = "Choisis la couleur de bordure", 
                  selectize = TRUE, multiple = FALSE,
                  choices = c("black", "grey", "blue", "orange", "red")),
      sliderInput(inputId = "nbbins",
                  label = "Choisis le nombre de barres",
                  min = 10,
                  max = 30,
                  value = 20)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plothist")
    )
  )
)

shinyApp(ui = ui, server = server)
