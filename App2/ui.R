##############################  
#### Shiny User interface ####
##############################

# Shiny ui ----

shinyUI(fluidPage(
  # Application title
  titlePanel("Outil interactif de classification hiérarchique"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variables", label = "Variables", 
                  selectize = TRUE, multiple = TRUE,
                  choices = colnames(eurosex)),
      selectInput(inputId = "typeDist",
                  label = "Type de distance",
                  selectize = TRUE,
                  multiple = FALSE,
                  choices = c("Euclidienne" = "euclidean", "Manhattan" = "manhattan")),
      sliderInput(inputId = "nbClasses",
                  label = "Nombre de classes",
                  min = 1,
                  max = 12,
                  value = 4),
      hr(),
      h3("Exercice"),
      tags$ol(
        tags$li("Ajouter un paramètre pour modifier le critère d'agrégation"),
        tags$li("Ajouter un paramètre permettant de standardiser les variables
                avant d'effectuer la CAH"),
        tags$li("Trouver une méthode pour que la CAH ne se calcule
                pas s'il n'y a pas au moins 2 variables de sélectionnées"),
        tags$li("La CAH est redécoupée pour chacun des graphiques :
                trouver un moyen pour que cette opération (cutree) ne soit réalisée
                que quand il y a un changement dans les variables/le nombre de classe")
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Graphiques",
                 icon = icon(name = "pencil-square-o"),
                 plotOutput("graphiqueBase"),
                 plotOutput("dendrogramme")),
        tabPanel(title = "Carte & Profils",
                 icon = icon(name = "picture-o"),
                 fluidRow(
                   column(6, plotOutput("carteCAH")),
                   column(6, plotOutput("profilsCAH"))
                   )
        ),
        tabPanel(title = "Tableaux", 
                 icon = icon(name = "table"),
                 dataTableOutput("tableau"))

      )
    )
  )
))
