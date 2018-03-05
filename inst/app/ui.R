fluidPage(

  titlePanel("Background Ions Remover"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Choose a raw data file'),
      fileInput('blank', 'Choose a blank sample'),
      selectInput('mode', 'How to define the targeted metabolite ?', c('tic', 'sum of pics')),
      uiOutput('pic_ctrl')
    ),

    mainPanel(

    )
  )
)
