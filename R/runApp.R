runDeBlank <- function(){
  appdir <- system.file('app', package = 'deblank')
  runApp(appdir, display.mode = 'normal')
}
