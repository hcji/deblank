library(shiny)
library(plotly)

function(input, output) {
  options(shiny.maxRequestSize=1024^3)

  raw_file <- reactive({
    req(input$file)
    withProgress(message = 'Loading the sample file', value = 0.5, {
      LoadData(input$file$datapath)
    })
  })
  raw_blank <- reactive({
    req(input$blank)
    withProgress(message = 'Loading the blank file', value = 0.5, {
      LoadData(input$blank$datapath)
    })
  })

  raw_deblank <- reactive(
    withProgress(message = 'Removing the baseline ions', value = 0.5, {
      deblank(raw_blank(), raw_file(), window=input$window, threshold=input$threshold, digit=as.numeric(input$digit))
    })
  )

  output$ctrlmsplot <- renderUI({
    if (as.logical(input$plotms)){
      tagList(numericInput('target_rt', 'Input the targeted retention time of ms to be plot', 0),
              actionButton('confirm', 'Confirm'))
    }
  })

  observeEvent(input$confirm, {
    output$ms_file_plot <- renderPlotly({
      req(input$target_rt)
      withProgress(message = 'Creating MS plot', value = 0.5, {
        ms <- getMS(raw_file(), input$target_rt)
        plotMS(ms)
      })
    })

    output$ms_blank_plot <- renderPlotly({
      req(input$target_rt)
      withProgress(message = 'Creating MS plot', value = 0.5, {
        ms <- getMS(raw_blank(), input$target_rt)
        plotMS(ms)
      })
    })

    output$ms_deblank_plot <- renderPlotly({
      req(input$target_rt)
      withProgress(message = 'Creating MS plot', value = 0.5, {
        ms <- getMS(raw_deblank(), input$target_rt)
        plotMS(ms)
      })
    })
  })

  output$tic_plot <- renderPlotly({
    withProgress(message = 'Creating TICs plot', value = 0.5, {
      tic_raw <- getTIC(raw_file())
      tic_blank <- getTIC(raw_blank())
      tic_deblank <- getTIC(raw_deblank())
      plotTIC(tic_raw, tic_blank, tic_deblank)
    })
  })


}
