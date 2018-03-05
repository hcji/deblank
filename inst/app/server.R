library(shiny)
library(plotly)

function(input, output) {
  options(shiny.maxRequestSize=1024^3)

  output$pic_ctrl <- renderUI({
    if(input$mode != 'tic') {
      tagList(
        numericInput('level', 'The minimum intensity of pics', 0),
        numericInput('mztol', 'The mz tolerence of pics', 0.01),
        numericInput('width', 'The minimum length of pics (s)', 5),
        numericInput('snr', 'The minimum signal-to-noise ratio of pics', 5)
      )
    }
  })

  output$file_plot <- renderPlotly({

  })


}
