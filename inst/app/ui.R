fluidPage(

  titlePanel("Background Ions Remover"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Choose a raw data file'),
      fileInput('blank', 'Choose a blank sample'),
      numericInput('window','Input the window size', 5),
      numericInput('threshold', 'Input the intensity threshold of the ion in blank sample', 100),
      selectInput('digit', 'Select the precision of decimal digits', choices = c(1, 2, 3, 4)),
      selectInput('plotms', 'Select whether plot ms of targeted retention time or not', choices = c(TRUE, FALSE)),
      uiOutput('ctrlplotms')
    ),

    mainPanel(
      h3('TICs of the datasets'),
      plotlyOutput('tic_plot'),

      h3('MS of targeted retention time'),
      h4('Sample:'),
      plotlyOutput('ms_file_plot'),
      h4('Blank:'),
      plotlyOutput('ms_blank_plot'),
      h4('Sample Deblank:'),
      plotlyOutput('ms_deblank_plot'),



    )
  )
)

