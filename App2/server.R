#################
### Commandes ###
### générales ###
#################

library(shiny)
library(ggplot2)
library(reshape2)

load("../data/eurosex.RData")
row.names(eurosex) <- eurosex$COUNTRYID



##################
### Machinerie ###
##################

shinyServer(function(input, output, session) {
  
  # Données à utiliser pour la classification
  donneesChoisies <- reactive({
    maSelection <- eurosex[, input$variables]
    return(maSelection)
  })
  
  # Réalisation de la CAH
  calculCAH <- reactive({
    maCAH <- hclust(d = dist(x = donneesChoisies(), method = input$typeDist), method = "ward.D2")
    return(maCAH)
  })
  
  # Graphique de contingence
  output$graphiqueBase <- renderPlot({
    numClasse <- cutree(calculCAH(), input$nbClasses)
    plot(donneesChoisies(),
         col = numClasse,
         pch = 20, cex = 3)
  })
  
  # Dendrogramme
  output$dendrogramme <- renderPlot({
    hierarTree <- as.dendrogram(calculCAH())
    plot(hierarTree, leaflab = "none")
  })
  
  # Sortie tabulaire
  output$tableau <- renderDataTable({
    eurosex$CLUSTER <- cutree(calculCAH(), input$nbClasses)
    return(eurosex)
  })
  
  # Carte des classes
  output$carteCAH <- renderPlot({
    par(mar = c(0,0,1,0))
    cPal <- rainbow(n = input$nbClasses)
    numClasse <- cutree(calculCAH(), input$nbClasses)
    countryColors <- cPal[numClasse] 
    plot(euromap, col = countryColors)
  })
  
  # Affichage des profils de classe
  output$profilsCAH <- renderPlot({
    data <- donneesChoisies()
    cPal <- rainbow(n = input$nbClasses)
    clusters <- cutree(calculCAH(), input$nbClasses)
    data$CLUSTER <- factor(clusters, levels = 1:input$nbClasses, labels = paste('Classe', 1:input$nbClasses, sep = " "))
    plotDF <- subset(data, select = -CLUSTER)
    clusProfile <- aggregate(plotDF,
                             by = list(data$CLUSTER),
                             mean)
    colnames(clusProfile)[1] <- "CLUSTER"
    clusLong <- melt(clusProfile, id.vars = "CLUSTER")
    ggplot(clusLong) +
      geom_bar(aes(x = variable, y = value, fill = CLUSTER),
               stat = "identity") +
      scale_fill_manual(values = cPal, guide = FALSE) +
      facet_wrap(~ CLUSTER) +
      coord_flip() + theme_bw()
  })
  
  
})
