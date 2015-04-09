#################
### Commandes ###
### générales ###
#################

library(shiny)

### On charge les données ###
load("../data/eurosex.RData")

##################
### Machinerie ###
##################

server <- function(input, output) {
  # Une fonction réactive qui renvoie un graphique
  output$plothist <- renderPlot({
    hist(x = eurosex$FREQYEAR,
         col = input$fillcol, 
         border = input$bordercol, 
         breaks = 5,
         main = "Distribution de la fréquence moyenne des rapports",
         xlab = "Nombre moyen de rapports / an",
         ylab = "Fréquence")
  })
}

#################
### Interface ###
## Utilisateur ##
#################

ui <- fluidPage(
  # Titre de l'application
  titlePanel("Avec shiny, personnalise ton histogramme !"),
  
  # Mise en page globale : Panneay latéral + page centrale
  sidebarLayout(
    
    # Panneau latéral de contrôle
    sidebarPanel(
      
      selectInput(inputId = "fillcol", label = "Choisis la couleur de remplissage", 
                  selectize = TRUE, multiple = FALSE,
                  choices = c("black", "grey", "blue", "orange", "red")),
      selectInput(inputId = "bordercol", label = "Choisis la couleur de bordure", 
                  selectize = TRUE, multiple = FALSE,
                  choices = c("black", "grey", "blue", "orange", "red"))
    
      ),
    
    # Panneau central
    mainPanel(
      
      # Sortie du graphique
      plotOutput("plothist"),
      
      
      # Pour l'exercice...
      hr(),
      h3("Exercice"),
      tags$ol(
        tags$li("Ajouter un paramètre pour contrôler le nombre de barres de l'histogramme"),
        tags$li("Ajout un paramètre pour choisir la variable à afficher")
        )
    )
  )
)

#################
### Execution ###
#################
shinyApp(ui = ui, server = server)
