library(shiny)

library(e1071)

#Model laden
model.svm <- readRDS("titanic.svm.rds")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  
  titlePanel("Wie hoch ist deine Chance auf der Titanic zu überleben?"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput("age", "Alter:",
                  min = 1, max = 100,
                  value = ""),
      
      radioButtons("sex", "Geschlecht:",
                   c("weiblich" = "1",
                     "männlich" = "0")),
      
      selectInput("pclass", selected = NULL, "Passagierklasse:",
                  c("1" = 1,
                    "2" = 2,
                    "3" = 3)),
      
      helpText("Bitte wählen sie Alter,Geschlecht und Passagierklasse aus. Keine Sorge ihre Daten werden nicht gespeichert"),
      
      actionButton("action", label = "Wirst du überleben?")
    ),
   
     
    mainPanel(
      tableOutput("value1")
    )
  )
)

# Define server logic required to draw a histogram ----

server <- function(input, output, session) {
  
  
  observeEvent(input$action, {
    pclass <- as.numeric(input$pclass)
    sex <- as.numeric(input$sex)
    age <- input$age
    data <- data.frame(pclass,sex,age)
    print(str(data))
    result <- predict(model.svm, data, probability = TRUE)
    my_result <- data.frame(attr(result, "probabilities"))
    output$value1 <- renderTable(my_result)
  })
  
  
  
}
# Create Shiny app ----
shinyApp(ui, server)