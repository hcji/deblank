fluidPage(

  titlePanel("Background Ions Remover"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Choose a raw data file'),
      fileInput('blank', 'Choose a blank sample'),
      numericInput('window','Input the window size', 5),
      numericInput('threshold', 'Input the intensity threshold of the ion in blank sample', 100),
      selectInput('digit', 'Select the precision of decimal digits', choices = c(1, 2, 3, 4))
    ),

    mainPanel(
      tabsetPanel(id = "tabs",
                  tabPanel('Sample'),
                  tabPanel('Blank'),
                  tabPanel('DeBlank')
      )
    )
  )
)
